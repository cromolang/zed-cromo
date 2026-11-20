# Cromo for Zed

[Cromo](https://cromolang.org) in the [Zed](https://zed.dev) editor: write, build, run, test and debug.

- **Syntax.** Highlighting, the outline of a file, brackets, indentation and the text objects of Vim mode, from the [Tree-sitter grammar of Cromo](https://github.com/cromolang/tree-sitter-cromo).
- **The language server.** Errors while typing, hover with the documentation, go to definition, the symbols of a file, completion after a dot, the help on the signature and formatting: it is `cromo lsp`, the same server of the other editors.
- **Build, run and test.** A run button next to `main` and next to each `[[test]]` function, and the tasks `cromo run`, `cromo build`, `cromo build --release`, `cromo test` and `cromo fmt` in the list of the tasks.
- **Debugging.** A task that runs or builds a file can be started in the debugger: the extension builds the file with `-O0` and gives the executable to the debugger.

## What it needs

`cromo` on the `PATH`: install it from [cromolang.org](https://cromolang.org). To use another one, in the settings of Zed:

```json
{
  "lsp": {
    "cromo": {
      "binary": { "path": "C:/cromo/bin/cromo.exe" }
    }
  }
}
```

## Debugging

Open the list of the debug sessions (`debugger: start`, F4) and choose a task of `cromo`, as `cromo run main.cro`: the extension builds `main.debug.exe` next to the source (`main.debug` on Linux) without optimizations, and starts it under the debugger, CodeLLDB or GDB.

A configuration written by hand goes in `.zed/debug.json` of the project:

```json
[
  {
    "label": "Debug main.cro",
    "adapter": "CodeLLDB",
    "request": "launch",
    "program": "$ZED_WORKTREE_ROOT/main.debug.exe",
    "cwd": "$ZED_WORKTREE_ROOT",
    "build": {
      "command": "cromo",
      "args": ["build", "-O0", "main.cro", "-o", "main.debug.exe"]
    }
  }
]
```

A program built without `--release` carries its lines, its functions and its local variables with the types of Cromo: a PDB next to the `.exe` on Windows, and DWARF in the executable. With `-O0` every variable stays where the debugger finds it.

## Developing the extension

It needs Rust, installed with `rustup`. In Zed, `zed: install dev extension` and choose this folder; `zed: open log` shows what went wrong. The grammar is taken from the repository and the commit named in `extension.toml`.

## License

MIT.
