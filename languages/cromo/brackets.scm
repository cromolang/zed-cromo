("(" @open
  ")" @close)

("{" @open
  "}" @close)

(list_literal
  "[" @open
  "]" @close)

(capture_list
  "[" @open
  "]" @close)

(index_expression
  "[" @open
  "]" @close)

(array_type
  "[" @open
  "]" @close)

; [[name]]: the outer pair and the inner pair.
(attribute
  .
  "[" @open
  "]" @close
  .)

(attribute
  .
  "["
  .
  "[" @open
  "]" @close
  .
  "]"
  .)

(type_arguments
  "<" @open
  ">" @close)

(type_parameters
  "<" @open
  ">" @close)

(string_literal
  "\"" @open
  "\"" @close)
