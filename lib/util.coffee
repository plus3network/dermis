module.exports =
  result: (v, scope) ->
    if typeof v is "function"
      return v.bind(scope)() if scope
      return v()
    return v
