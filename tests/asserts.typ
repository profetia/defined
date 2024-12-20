#import "../src/defined.typ": *

#let test-define = {
  let scope = state("--test-scope", (:))

  context assert(not defined("foo", from: scope))
  define("foo", from: scope)(true)
  context assert(defined("foo", from: scope))

  context assert(not defined(from: scope)[bAr])
  define("bAr", from: scope)(true)
  context assert(defined(from: scope)["bAr"])

  [run `test-define` successfully]
}

#let test-from-scope = {
  let scope = state("--test-from-scope", (:))

  context assert(not defined("foo", from: scope))
  context assert(not defined("bAr", from: scope))

  from-scope((foo: true, bAr: true), from: scope)

  context assert(defined("foo", from: scope))
  context assert(defined("bAr", from: scope))

  [run `test-from-scope` successfully]
}

#let test-sys = {
  let has-foo = sys.inputs.keys().contains("foo")

  context assert(not has-foo or defined("foo"))

  [run `test-sys` successfully]
}

#let test-undef = {
  let scope = state("--test-undef", (:))

  define("foo", from: scope)(true)
  context assert(defined("foo", from: scope))

  undef("foo", from: scope)
  context assert(not defined("foo", from: scope))

  [run `test-undef` successfully]
}

#let test-resolve = {
  let scope = state("--test-resolve", (:))

  define("foo", from: scope)(("f", "o", "o"))
  context assert(defined("foo", from: scope))
  context assert.eq(resolve("foo", from: scope), ("f", "o", "o"))

  context assert(not defined("bAr", from: scope))
  context assert.eq(resolve("bAr", from: scope), none)

  [run `test-resolve` successfully]
}

#let test-expand = {
  let scope = state("--test-expand", (:))

  define("foo", from: scope)(1)
  define("bAr", from: scope)(2)
  context assert.eq(expand("foo + bAr", from: scope), 3)

  [run `test-expand` successfully]
}

= Run tests (#datetime.today().display())

- #test-define
- #test-from-scope
- #test-sys
- #test-undef
- #test-resolve
- #test-expand
