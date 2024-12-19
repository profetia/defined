#import "../src/defined.typ": *

#let test_define = {
  context assert(not defined("foo"))
  define("foo")(true)
  context assert(defined("foo"))
  context assert(not defined("foo", from: (:)))

  context assert(not defined[bAr])
  define("bAr")(true)
  context assert(defined["bAr"])

  [run `test_define` successfully]
}

= Run tests (#datetime.today().display())

- #test_define

