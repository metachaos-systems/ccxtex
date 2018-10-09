# Used by "mix format"
locals_without_parens = [
  # construct
  structure: 1,
  field: 1,
  field: 2,
  field: 3
]

[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens
]
