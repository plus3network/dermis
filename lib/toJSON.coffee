module.exports = toJSON = (val) ->
  if Array.isArray val
    return (toJSON(i) for i in val)
  else if val? and typeof val.toJSON is 'function'
    return val.toJSON()
  else if typeof val is "object"
    out = {}
    out[k] = toJSON v for own k,v of val
    return out
  return val