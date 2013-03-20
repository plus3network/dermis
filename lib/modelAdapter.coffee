module.exports = adapter =
  get: (o, k) ->
    if o._isCollection and /^\d+$/.test k
      return o.at k
    if o._isModel
      return o.get k
    return o[k]

  set: (silent) -> (o, k, v) ->
    if typeof v isnt 'undefined'
      return adapter.del o, k, silent if v is null

      if o._isCollection and /^\d+$/.test k
        o.replaceAt parseInt(k), v, silent
      else if o._isModel
        o.set k, v, silent
      else
        o[k]=v
    return adapter.get o, k

  del: (o, k, silent) ->
    if o._isCollection and /^\d+$/.test k
      o.removeAt parseInt(k), silent
    else if o._isModel
      delete o._props[k]
    else
      delete o[k]
    return