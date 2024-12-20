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

#let test-from-toml = {
  let scope = state("--test-from-toml", (:))

  context assert(not defined("foo", from: scope))
  context assert(not defined("bAr", from: scope))

  from-toml("../tests/asserts.toml", from: scope)

  context assert(defined("foo", from: scope))
  context assert(defined("bAr", from: scope))

  [run `test-from-toml` successfully]
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

= Run tests (#datetime.today().display())

- #test-define
- #test-from-scope
- #test-from-toml
- #test-sys
- #test-undef
- #test-resolve
