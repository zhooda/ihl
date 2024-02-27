(lang dune 3.14)

(name ihl)

(generate_opam_files true)

(source
 (github zhooda/ihl))

(authors "Zeeshan Hooda")

(maintainers "Zeeshan Hooda")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name ihl)
 (synopsis "A DSL for working with Large Language Models")
 (description "IHL (I Hate LLMs) is a DSL for those who need to use LLMs but find them frustratingly annoying to work with.")
 (depends ocaml dune)
 (tags
  (topics llm ai ml agent "prompt engineering")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
