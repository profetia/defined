#import "@preview/valkyrie:0.2.1" as z

#import "utils.typ":*

/// A dictionary of defined values.
#let scope = state("defined-scope", (:))

/// Check if a value is defined.
/// - name (string): The name of the value to check.
/// - from (state): The scope to check the value in.
/// -> (boolean): Whether the value is defined.
#let defined(name, from: scope) = {
  type-check(name, z.either(z.content(), z.string()))

  let real-name = stringfy(name)

  type-check(from.get(), z.dictionary((:)))
  return from.get().keys().contains(real-name)
}

/// Define a value.
/// - name (string): The name of the value to define.
/// - from (state): The scope to define the value in.
/// -> (function): A function that takes a value and defines it.
#let define(name, from: scope) = {
  let real-name = stringfy(name)

  let fn(value) = {
    from.update((inner) => {
      inner.insert(real-name, value)
      return inner
    })
  }

  return fn
}

#let from-scope(data, from: scope) = {
  type-check(data, z.dictionary((:)))

  from.update((inner) => {
    for (key, value) in data {
      inner.insert(key, value)
    }
    return inner
  })
}