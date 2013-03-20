module.exports = toJSON = (val) ->
  if Array.isArray val
    return (toJSON(i) for i in val)
  else if typeof val is "object"
    return val.toJSON() if typeof val.toJSON is 'function'
    out = {}
    out[k] = toJSON v for own k,v of val
    return out
  return val