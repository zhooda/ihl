open Core

let ratio x y =
  x /. y

let () =
  Sexp.to_string_hum [%sexp ([3;4;5] : int list)]
  |> print_endline
