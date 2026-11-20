(function_definition
  body: (block
    "{"
    (_)* @function.inside
    "}")) @function.around

(method_definition
  body: (block
    "{"
    (_)* @function.inside
    "}")) @function.around

(constructor_definition
  body: (block
    "{"
    (_)* @function.inside
    "}")) @function.around

(destructor_definition
  body: (block
    "{"
    (_)* @function.inside
    "}")) @function.around

(lambda_expression
  body: (block
    "{"
    (_)* @function.inside
    "}")) @function.around

(method_signature) @function.around

(function_signature) @function.around

(struct_declaration
  body: (struct_body
    "{"
    (_)* @class.inside
    "}")) @class.around

(enum_declaration
  body: (enum_body
    "{"
    (_)* @class.inside
    "}")) @class.around

(interface_declaration
  body: (interface_body
    "{"
    (_)* @class.inside
    "}")) @class.around

(comment)+ @comment.around

(comment) @comment.inside
