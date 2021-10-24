{ sources = [ "src/**/*.purs", "test/**/*.purs" ]
, name = "purescript-elmish-examples-counter: Counterexample"
, dependencies =
  [ "aff", "debug", "effect", "elmish", "elmish-html", "psci-support", "uuid" ]
, packages = ./packages.dhall
}
