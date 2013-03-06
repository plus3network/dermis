mixer = require 'mixer'
rivets = require 'rivets'
syncAdapter = require './syncAdapter'

class Model extends mixer.Module
  sync: syncAdapter

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