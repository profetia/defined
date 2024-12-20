#import "../src/lib.typ": *
#import "@preview/gentle-clues:0.7.1": abstract, quote as _quote

#let l = [_defined_]

#set text(font: "Rubik", weight: 300)
#set heading(numbering: (..args) => {}) //needed for ref to work

#show raw.where(block: false): it => {
  box(fill: luma(240), radius: 5pt, inset: (x: 3pt), outset: (y: 3pt), it)
}
#show link: set text(fill: blue)
#show quote.where(block: false): it => {
  ["] + h(0pt, weak: true) + it.body + h(0pt, weak: true) + ["]
  if it.attribution != none [ (#it.attribution) ]
}

#let pkginfo = toml("../typst.toml").package

// title
#align(center, text(24pt, weight: 500)[defined manual])

#abstract[
  #link("https://github.com/profetia/defined")[*defined*] is a package to make conditional compilation easily.

  Version: #pkginfo.version \
  Authors: #link("https://github.com/profetia", "profetia") \
  License: #pkginfo.license
]

#outline(depth: 2, indent: 2em)

#v(1cm)

This manual shows a short example for the usage of the `defined` package inside your document. If you want to *include
defined into your package* make sure to read the #ref(<4pck>, supplement: "section for package authors").

#pagebreak()
= Usage

== Basic example

#v(1em)

*Check if a macro is defined:*

```typc
#context if defined[CONFIG_DEBUG] [
  Debugging is enabled.
]
```

#table(
  columns: 2,
  inset: 1em,
  align: (center, start),
  table.header([*Options*], [*Output*]),
  [\<empty\>],
  [\<empty\>],
  [--input CONFIG_DEBUG=1],
  [Debugging is enabled.],
)

You are allowed to use [..] to call the functions in the package, making it look like a macro. The function will try to
interpret the markup as a string.

*Define a macro:*

```typc
#define[CONFIG_DEBUG](1)
```

*Define macros from a dictionary:*

```typc
#from-scope(toml("config.toml"))
```

*Unset a macro:*

```typc
#undef[CONFIG_DEBUG]
```

*Resolve a macro to a value:*

```typc
#context resolve[CONFIG_DEBUG]
```

*Expand and evaluate macros*

```typc
#context expand("assert.eq(CONFIG_DEBUG, 1)")
```

== Information for package authors.<4pck>

As the scope is stored in a typst state, it can be overwritten. This leads to the following problem. If you use #l inside
your package and use the `define()` or `from-scope()` function it will probably work like you expect. But if a user
imports your package and uses #l for their own document as well, he will overwrite the your scope by using `define` or
`from-scope`. Therefore it is recommend to use the `from` argument in the functions of #l to specify your scope
directly.

Example: ```typc
#let my-scope = toml("lang.toml")

#defined("key", from: my-scope)
```

This makes sure the end user still can use the global scope provided by #l.

#pagebreak()
= Reference

#import "@preview/tidy:0.2.0"
#let docs = tidy.parse-module(read("../src/defined.typ"), name: "Defined reference")
#tidy.show-module(docs, style: tidy.styles.default, show-outline: false, sort-functions: none)
