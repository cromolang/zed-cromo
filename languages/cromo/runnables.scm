; The program: `i32 main(list<string> args)` or `void main()`.
(
  (source_file
    (function_definition
      name: (identifier) @run
      (#eq? @run "main")) @_cromo_main)
  (#set! tag cromo-main)
)

; A test: `[[test]] void name()`. A task finds its name in $ZED_CUSTOM_test_name.
(
  (source_file
    (function_definition
      (attribute
        name: (identifier) @_attribute)
      name: (identifier) @run @test_name
      (#eq? @_attribute "test")) @_cromo_test)
  (#set! tag cromo-test)
)
