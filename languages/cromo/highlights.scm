; Highlights for Cromo, with the capture names of Zed.
; Later patterns win over earlier ones.

; ---- Names ----

(identifier) @variable

((identifier) @type
  (#match? @type "^[A-Z]([a-z0-9][A-Za-z0-9_]*)?$"))

((identifier) @constant
  (#match? @constant "^[A-Z][A-Z0-9_]+$"))

(type_identifier) @type

((type_identifier) @type.builtin
  (#match? @type.builtin "^(i8|i16|i32|i64|u8|u16|u32|u64|f32|f64|bool|char|string|list|map|addr|Self|([iu](8|16|32|64)|f(32|64))x(2|4|8|16|32))$"))

(void_type) @type.builtin

(qualified_type
  module: (identifier) @variable.special)

(module_path
  (identifier) @variable.special)

; ---- Declarations ----

(parameter
  name: (identifier) @variable.parameter)

(pattern_binding
  name: (identifier) @variable.parameter)

(catch_clause
  name: (identifier) @variable.parameter)

(for_binding
  name: (identifier) @variable)

(variable_declaration
  name: (identifier) @variable)

(source_file
  (variable_declaration
    "const"
    name: (identifier) @constant))

(field_declaration
  name: (identifier) @property)

(field_expression
  field: (identifier) @property)

(enum_case
  name: (identifier) @variant)

(case_pattern
  name: (identifier) @variant)

((field_expression
  field: (identifier) @variant)
  (#match? @variant "^[A-Z]"))

(function_definition
  name: (identifier) @function)

(function_signature
  name: (identifier) @function)

(method_definition
  name: (identifier) @function)

(method_signature
  name: (identifier) @function)

(constructor_definition
  name: (identifier) @constructor)

(destructor_definition
  "~" @constructor
  name: (identifier) @constructor)

; ---- Calls ----

(call_expression
  function: (identifier) @function)

(call_expression
  function: (field_expression
    field: (identifier) @function))

; A call of a name with a capital letter builds a struct or a case of an enum.
((call_expression
  function: (identifier) @constructor)
  (#match? @constructor "^[A-Z]"))

((call_expression
  function: (field_expression
    field: (identifier) @variant))
  (#match? @variant "^[A-Z]"))

; A conversion: i32(x), string(n).
((call_expression
  function: (identifier) @type.builtin)
  (#match? @type.builtin "^(i8|i16|i32|i64|u8|u16|u32|u64|f32|f64|bool|char|string|list|map|addr|([iu](8|16|32|64)|f(32|64))x(2|4|8|16|32))$"))

((call_expression
  function: (identifier) @function.builtin)
  (#match? @function.builtin "^(print|println|eprint|eprintln|format|panic|assert|wrapAdd|wrapSub|wrapMul|embed|countOnes|trailingZeros|leadingZeros|rotateLeft|rotateRight|fma)$"))

; ---- Attributes ----

(attribute
  name: (identifier) @attribute)

(attribute_arguments
  (identifier) @constant)

; ---- Literals ----

(integer_literal) @number

(float_literal) @number

(char_literal) @string

(string_literal) @string

(escape_sequence) @string.escape

(placeholder) @string.special

(boolean_literal) @boolean

(comment) @comment

; ---- Keywords ----

[
  "case"
  "catch"
  "const"
  "default"
  "else"
  "enum"
  "extend"
  "extern"
  "finally"
  "for"
  "func"
  "if"
  "import"
  "in"
  "interface"
  "move"
  "public"
  "ref"
  "ret"
  "struct"
  "switch"
  "throw"
  "try"
  "unsafe"
] @keyword

(break_statement) @keyword

(continue_statement) @keyword

; ---- Operators and punctuation ----

[
  "+"
  "-"
  "*"
  "/"
  "%"
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "&="
  "|="
  "^="
  "<<="
  "=="
  "!="
  "<"
  "<="
  ">"
  ">="
  "&&"
  "||"
  "!"
  "&"
  "|"
  "^"
  "<<"
  "++"
  "--"
  "?"
  ":"
] @operator

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

(type_arguments
  [
    "<"
    ">"
  ] @punctuation.bracket)

(type_parameters
  [
    "<"
    ">"
  ] @punctuation.bracket)

[
  ","
  "."
  ";"
] @punctuation.delimiter

(interface_list
  ":" @punctuation.delimiter)

(type_parameter
  ":" @punctuation.delimiter)
