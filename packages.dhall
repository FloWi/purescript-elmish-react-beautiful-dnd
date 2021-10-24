let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.1-20210427/packages.dhall sha256:edbb8f70232fb83895c7ce02f5d2b29f6ee1722f1a70fc58d3bc0ab0de18afe4

in  upstream
  with elmish.version = "v0.5.0"
  with elmish-html.version = "v0.3.0"
  with debug.version = "v5.0.0"
