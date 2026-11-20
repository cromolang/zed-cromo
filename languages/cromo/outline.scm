(struct_declaration
  "public"? @context
  "struct" @context
  name: (type_identifier) @name) @item

(enum_declaration
  "public"? @context
  "enum" @context
  name: (type_identifier) @name) @item

(interface_declaration
  "public"? @context
  "interface" @context
  name: (type_identifier) @name) @item

(enum_case
  name: (identifier) @name) @item

(field_declaration
  "public"? @context
  type: (_) @context
  name: (identifier) @name) @item

; Functions, the tests among them: `[[test]] void name()`.
(function_definition
  (attribute)* @context
  "public"? @context
  return_type: (_) @context
  name: (identifier) @name
  parameters: (parameter_list
    "(" @context
    ")" @context)) @item

(method_definition
  "public"? @context
  return_type: (_) @context
  name: (identifier) @name
  parameters: (parameter_list
    "(" @context
    ")" @context)) @item

(constructor_definition
  "public"? @context
  name: (identifier) @name
  parameters: (parameter_list
    "(" @context
    ")" @context)) @item

(destructor_definition
  "~" @context
  name: (identifier) @name
  parameters: (parameter_list
    "(" @context
    ")" @context)) @item

(method_signature
  return_type: (_) @context
  name: (identifier) @name
  parameters: (parameter_list
    "(" @context
    ")" @context)) @item

(extern_block
  "extern" @context
  library: (string_literal) @name) @item

(function_signature
  return_type: (_) @context
  name: (identifier) @name
  parameters: (parameter_list
    "(" @context
    ")" @context)) @item

; The constants and the variables of a module.
(source_file
  (variable_declaration
    "const"? @context
    type: (_) @context
    name: (identifier) @name) @item)
