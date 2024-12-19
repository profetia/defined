#import "../src/lib.typ": *

#let test-define = {
  let scope = state("__test-scope", (:))

  context assert(not defined("foo", from: scope))
  define("foo", from: scope)(true)
  context assert(defined("foo", from: scope))

  context assert(not defined(from: scope)[bAr])
  define("bAr", from: scope)(true)
  context assert(defined(from: scope)["bAr"])

  [run `test-define` successfully]
}

#let test-from-scope = {
  let scope = state("__test-from-scope", (:))

  context assert(not defined("foo", from: scope))
  context assert(not defined("bAr", from: scope))

  from-scope((foo: true, bAr: true), from: scope)

  context assert(defined("foo", from: scope))
  context assert(defined("bAr", from: scope))

  [run `test-from-scope` successfully]
}

= Run tests (#datetime.today().display())

- #test-define
- #test-from-scope
