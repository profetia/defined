#import "@preview/valkyrie:0.2.1" as z

#import "utils.typ":*

/// A dictionary of defined values.
#let database = state("defined-database", (:))

/// Check if a value is defined.
/// - name (string): The name of the value to check.
/// - from (state): The database to check the value in.
/// -> (boolean): Whether the value is defined.
#let defined(name, from: database) = {
  type-check(name, z.either(z.content(), z.string()))

  let real-name = stringfy(name)

  if type(from) == state {
    type-check(from.get(), z.dictionary((:)))
    return from.get().keys().contains(real-name)
  }

  type-check(from, z.dictionary((:)))
  return from.keys().contains(real-name)
}

/// Define a value.
/// - name (string): The name of the value to define.
/// - from (state): The database to define the value in.
/// -> (function): A function that takes a value and defines it.
#let define(name, from: database) = {
  let real-name = stringfy(name)

  let fn(value) = {
    from.update((inner) => {
      inner.insert(real-name, value)
      return inner
    })
  }

  return fn
}
