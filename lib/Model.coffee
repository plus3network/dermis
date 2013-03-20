rivets = require 'rivets'
syncAdapter = require './syncAdapter'
Emitter = require 'emitter'
mpath = require 'mpath'
adapter = require './modelAdapter'
toJSON = require './toJSON'

# # Model
# Models are like standard objects but with a punch.
#
# With dermis models you can observe, sync, and use a set of utility functions to speed up your development.
#
# You can create a simple model by doing ```new dermis.Model()```
#
# To extend or create a custom model see the [Extending documentation](../manual/Extending.html)

class Model extends Emitter
  @_isModel: true
  _isModel: true

  # ### sync
  # Override this to change the sync adapter for the model.
  #
  # Defaults to built-in REST adapter

  sync: syncAdapter

  # ### casts
  # An object of things to cast on .set(). Works with collections, models, and functions.
  #
  # Example:
  #
  # ```{casts: {dog: Pet}}``` will cause ```.set({name:'Tom', dog:{name:'Fido'}})``` to do the equivalent of ```.set({name:'Tom', dog: new Pet({name:'Fido'})})```
  
  casts: null

  # ### defaults
  # Default values to be .set() after .construct()

  defaults: null

  # ### constructor(properties)
  # Creates a new Model
  #
  # properties object is optional but if given it will .set() them

  constructor: (o) ->
    @_fetched = false
    @_props = {}
    @casts ?= {}

    @set @defaults if @defaults?
    @set o unless Array.isArray o # prevent us from messing up collections

  # ### get(key)
  # Returns the value for given key

  get: (k) -> mpath.get k, @_props, adapter.get

  # ### set(key, val, silent=false)
  # Sets the value of key to val
  #
  # Will emit ```change:{key}``` event unless silent is true
  #
  # Returns the model for chaining purposes

  set: (k, v, silent) ->
    return unless k?
    if typeof k is 'object'
      silent = v
      @set ky, vy, silent for ky,vy of k
      return @
    else
      # cast val
      castModel = @casts[k]
      if castModel?
        if castModel._isModel
          v = new castModel v
        else
          v = castModel v

      mpath.set k, v, @_props, adapter.set silent

      unless silent
        @emit "change", k, v
        @emit "change:#{k}", v
      return @

  # ### clear(silent=false)
  # Removes all properties from the model
  #
  # Will emit ```remove:{key}``` event for each property unless silent is true
  #
  # Returns the model for chaining purposes

  clear: (silent) ->
    @remove k, silent for own k,v of @_props
    return @

  # ### has(key)
  # Returns true or false if the model has a property with the given name

  has: (k) -> @get(k)?

  # ### remove(key, silent=false)
  # Removes property with given name from the model
  #
  # Will emit ```remove:{key}``` event unless silent is true
  #
  # Returns the model for chaining purposes

  remove: (k, silent) ->
    @set k, null, true
    unless silent
      @emit "change", k
      @emit "change:#{k}"

      @emit "remove", k
      @emit "remove:#{k}"
    return @

  # ### toJSON()
  # Returns a standard object with all model properties

  toJSON: -> toJSON @_props

  # ### fetch(options, callback)
  # See [Syncing documentation](../manual/Syncing.html) for possible options.
  #
  # callback is optional and will be called with ```(error, response)``` if given.
  #
  # Will emit fetching, fetched, and fetchError events.
  #
  # Will use either model.url or model.urls.read for GET request
  #
  # Will .set() object received in response
  #
  # Returns model for chaining purposes

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
      @_fetched = true
      @emit "fetched", res
      cb err, res if cb
    return @

  # ### save(options, callback)
  # See [Syncing documentation](../manual/Syncing.html) for possible options.
  #
  # callback is optional and will be called with ```(error, response)``` if given.
  #
  # Will emit saving, saved, and saveError events.
  #
  # Will use either model.url or model.urls.update for PUT request
  #
  # Returns model for chaining purposes

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

  # ### create(options, callback)
  # See [Syncing documentation](../manual/Syncing.html) for possible options.
  #
  # callback is optional and will be called with ```(error, response)``` if given.
  #
  # Will emit creating, created, and createError events.
  #
  # Will use either model.url or model.urls.create for POST request
  #
  # Returns model for chaining purposes

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

  # ### destroy(options, callback)
  # See [Syncing documentation](../manual/Syncing.html) for possible options.
  #
  # callback is optional and will be called with ```(error, response)``` if given.
  #
  # Will emit destroying, destroyed, and destroyError events.
  #
  # Will use either model.url or model.urls.create for DELETE request
  #
  # Returns model for chaining purposes

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

  # ### fetched(fn)
  # Calls given function when model has fetched or if it has already. Kind of like domReady for your model.
  #
  # Returns model for chaining purposes
  
  fetched: (cb) ->
    if @_fetched
      cb()
    else
      @once "fetched", cb
    return @

  # ### bind(el)
  # Binds model properties to a DOM element using dermis data binding.
  #
  # See [Binding documentation](../manual/Binding.html) for more information.
  #
  # Returns model for chaining purposes
  
  bind: (el) ->
    rivets.bind el, @
    return @

module.exports = Model