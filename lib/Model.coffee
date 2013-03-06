rivets = require 'rivets'
syncAdapter = require './syncAdapter'
Emitter = require 'emitter'

class Model extends Emitter
  sync: syncAdapter

  constructor: (o) ->
    @_props = {}
    @set o

  get: (k) -> @_props[k]

  set: (k, v, silent) ->
    return unless k?
    if typeof k is 'object'
      silent = v
      @set ky, vy, silent for ky,vy of k
      return @
    else
      @_props[k] = v
      unless silent
        @emit "change", k, v
        @emit "change:#{k}", v
      return @

  clear: (silent) ->
    @remove k, silent for k,v of @_props
    return @

  has: (k) -> @_props[k]?

  remove: (k, silent) -> 
    delete @_props[k]
    unless silent
      @emit "change", k
      @emit "change:#{k}"

      @emit "remove", k
      @emit "remove:#{k}"
    return @

  toJSON: -> @_props

  fetch: (opt, cb) ->
    if typeof opt is 'function' and !cb
      cb = opt
      opt = {}
    @emit "fetching", opt
    @sync 'read', @, opt, (err, res) =>
      if err?
        @emit "fetchError", err
        cb err if cb
        return
      @set res.body if typeof res.body is 'object'
      @emit "fetched", res
      cb err, res if cb
    return @

  save: (opt, cb) ->
    if typeof opt is 'function' and !cb
      cb = opt
      opt = {}
    @emit "saving", opt
    @sync 'update', @, opt, (err, res) =>
      if err?
        @emit "saveError", err
        cb err if cb
        return
      @emit "saved", res
      cb err, res if cb
    return @

  create: (opt, cb) ->
    if typeof opt is 'function' and !cb
      cb = opt
      opt = {}
    @emit "creating", opt
    @sync 'create', @, opt, (err, res) =>
      if err?
        @emit "createError", err
        cb err if cb
        return
      @emit "created", res
      cb err, res if cb
    return @

  destroy: (opt, cb) ->
    if typeof opt is 'function' and !cb
      cb = opt
      opt = {}
    @emit "destroying", opt
    @sync 'destroy', @, opt, (err, res) =>
      if err?
        @emit "destroyError", err
        cb err if cb
        return
      @emit "destroyed", res
      cb err, res if cb
    return @

  bind: (el) ->
    rivets.bind el, @

module.exports = Model