[
  (formals)
  (attrset_expression)
  (rec_attrset_expression)
  (list_expression)
  (parenthesized_expression)
  (binding)
  (string_expression)
] @indent.begin

[
  ")"
  "]"
  "}"
  "''"
  ";"
] @indent.end @indent.branch

(let_expression 
  (binding_set) @indent.begin (#set! indent.start_at_same_line 1) 
  )

(let_expression "in" @indent.branch)

