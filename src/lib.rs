// Cromo for Zed: starts the language server of `cromo`, and tells the debugger
// how to build a program and where its executable is.
use zed_extension_api::{
    self as zed, settings::LspSettings, BuildTaskDefinition, BuildTaskDefinitionTemplatePayload, DebugRequest,
    DebugScenario, LanguageServerId, LaunchRequest, Result, TaskTemplate, Worktree,
};

struct CromoExtension;

/// The name of the locator in `extension.toml`.
const LOCATOR: &str = "cromo";

/// The `cromo` to run: the one of the settings of the language server, or the one on
/// the PATH of the project.
fn find_cromo(worktree: &Worktree) -> Result<String> {
    if let Ok(settings) = LspSettings::for_worktree("cromo", worktree) {
        if let Some(path) = settings.binary.and_then(|binary| binary.path) {
            return Ok(path);
        }
    }
    worktree.which("cromo").ok_or_else(|| {
        "cromo was not found on the PATH: install it from https://cromolang.org, or set lsp.cromo.binary.path in the settings"
            .to_string()
    })
}

/// The source file that a task of `cromo` compiles: the first argument that ends with
/// `.cro`, before a `--` that starts the arguments of the program.
fn source_of(args: &[String]) -> Option<&String> {
    args.iter().take_while(|arg| arg.as_str() != "--").find(|arg| arg.ends_with(".cro"))
}

/// Where `cromo build file.cro -o <this>` writes the executable to debug: next to the
/// source, with a name of its own so that the program built for a run stays as it is.
fn debug_executable(source: &str) -> String {
    let stem = source.strip_suffix(".cro").unwrap_or(source);
    let (os, _) = zed::current_platform();
    match os {
        zed::Os::Windows => format!("{stem}.debug.exe"),
        _ => format!("{stem}.debug"),
    }
}

fn is_cromo(command: &str) -> bool {
    let name = command.rsplit(['/', '\\']).next().unwrap_or(command);
    name == "cromo" || name == "cromo.exe"
}

impl zed::Extension for CromoExtension {
    fn new() -> Self {
        CromoExtension
    }

    fn language_server_command(&mut self, _id: &LanguageServerId, worktree: &Worktree) -> Result<zed::Command> {
        let mut args = vec!["lsp".to_string()];
        if let Ok(settings) = LspSettings::for_worktree("cromo", worktree) {
            if let Some(more) = settings.binary.and_then(|binary| binary.arguments) {
                args = more;
            }
        }
        Ok(zed::Command { command: find_cromo(worktree)?, args, env: Default::default() })
    }

    /// A task that runs or builds a Cromo file can be debugged: the scenario builds the
    /// same file without optimizations, and then the locator says where the executable is.
    fn dap_locator_create_scenario(
        &mut self,
        locator_name: String,
        build_task: TaskTemplate,
        resolved_label: String,
        debug_adapter_name: String,
    ) -> Option<DebugScenario> {
        if locator_name != LOCATOR || !is_cromo(&build_task.command) {
            return None;
        }
        let verb = build_task.args.first()?;
        if verb != "run" && verb != "build" {
            return None;
        }
        let source = source_of(&build_task.args)?.clone();
        let template = TaskTemplate {
            label: format!("cromo build {source}"),
            command: build_task.command.clone(),
            // -O0 keeps every variable where a debugger finds it, and no function inside another.
            args: vec!["build".to_string(), "-O0".to_string(), source.clone(), "-o".to_string(), debug_executable(&source)],
            env: build_task.env.clone(),
            cwd: build_task.cwd.clone(),
        };
        Some(DebugScenario {
            label: format!("Debug: {resolved_label}"),
            adapter: debug_adapter_name,
            build: Some(BuildTaskDefinition::Template(BuildTaskDefinitionTemplatePayload {
                locator_name: Some(LOCATOR.to_string()),
                template,
            })),
            config: "{}".to_string(),
            tcp_connection: None,
        })
    }

    /// After the build of the scenario: the program to start is what `-o` named.
    fn run_dap_locator(&mut self, locator_name: String, build_task: TaskTemplate) -> Result<DebugRequest, String> {
        if locator_name != LOCATOR {
            return Err(format!("unknown locator {locator_name}"));
        }
        let output = build_task
            .args
            .iter()
            .position(|arg| arg == "-o")
            .and_then(|at| build_task.args.get(at + 1))
            .ok_or_else(|| "the build of cromo has no -o: there is no executable to debug".to_string())?;
        Ok(DebugRequest::Launch(LaunchRequest {
            program: output.clone(),
            cwd: build_task.cwd.clone(),
            args: Vec::new(),
            envs: build_task.env.clone(),
        }))
    }
}

zed::register_extension!(CromoExtension);
