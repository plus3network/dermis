Emitter = require 'emitter'
rivets = require 'rivets'
rivetsConfig = require './rivetsConfig'
Model = require './Model'

# # Collection
# Collections are like standard arrays but with a punch.
#
# With dermis collections you can observe, cast, sync, and use a set of utility functions to speed up your development.
#
# Collections are also [Model](Model.html)s so you can do all of the standard [Model](Model.html) stuff on it too. See the [Model documentation](Model.html) for more details.
#
# You can create a simple collection by doing ```new dermis.Collection()```
#
# To extend or create a custom collection see the [Extending documentation](../manual/Extending.html)

class Collection extends Model
  @_isCollection: true
  _isCollection: true

  # ### constructor(items)
  # Creates a new Collection
  #
  # items array is optional but if given it will .add() them

  constructor: (items) ->
    super
    @set 'models', [] unless @has 'models'
    @add items if Array.isArray items

  # ### model
  # Settings this to a [Model](Model.html) will cast all objects added to the given model.

  model: null
  # ### add(toAdd, silent=false)
  # Adds the given object to the collection. toAdd can also be an array of objects.
  #
  # Will emit ```change:models``` and ```add``` events unless silent is true
  #
  # Will cast object to a [Model](Model.html) if the collection has a model property.
  #
  # Returns the collection for chaining purposes.

  add: (o, silent) ->
    if Array.isArray o
      @add i, silent for i in o
      return @

    mod = @_processModel o
    @get('models').push mod
    @set 'models', @get('models'), silent
    unless silent
      @emit "add", mod
    return @

  # ### remove(toRemove, silent=false)
  # Removes the given object from the collection. toRemove can also be an array of objects.
  #
  # Will emit ```change:models``` and ```remove``` events unless silent is true
  #
  # Returns the collection for chaining purposes.

  remove: (o, silent) ->
    if Array.isArray o
      @remove i, silent for i in o
      return @
    idx = @indexOf o
    if idx isnt -1
      @get('models').splice idx, 1
      @set 'models', @get('models'), silent
      unless silent
        @emit "remove", o
    return @

  # ### removeAt(index, silent=false)
  # Removes the object at the given index from the collection.
  #
  # Will emit ```change:models``` and ```remove``` events unless silent is true
  #
  # Returns the collection for chaining purposes.

  removeAt: (idx, silent) ->
    @remove @at(idx), silent

  # ### replace(toReplace, obj, silent=false)
  # Replaces toReplace with obj in the collection
  #
  # Will emit ```change:models``` event unless silent is true
  #
  # Returns the collection for chaining purposes.

  replace: (o, nu, silent) ->
    idx = @indexOf o
    if idx isnt -1
      @replaceAt idx, nu, silent
    return @

  # ### replaceAt(index, obj, silent=false)
  # Replaces the object at the given index with the provided object.
  #
  # Will emit ```change:models``` unless silent is true
  #
  # Returns the collection for chaining purposes.

  replaceAt: (idx, nu, silent) ->
    mods = @get 'models'
    mods[idx] = @_processModel nu
    @set 'models', mods, silent
    return @

  # ### reset(newItems, silent=false)
  # Removes all items from the collection.
  #
  # Will add newItems to the collection if given. newItems can be an object or array of objects.
  #
  # Will emit ```change:models``` and ```reset``` events unless silent is true
  #
  # Returns the collection for chaining purposes.

  reset: (o, silent) ->
    if typeof o is 'boolean'
      silent = o
      o = null

    if o
      @set 'models', [], true
      @add o, silent
    else
      @set 'models', [], silent
    @emit "reset" unless silent
    return @

  # ### indexOf(object)
  # Returns the index of the given object in the collection.

  indexOf: (o) -> @get('models').indexOf o

  # ### at(index)
  # Returns the value at the given index in the collection.

  at: (idx) -> @get('models')[idx]

  # ### first()
  # Returns the first value in the collection.

  first: -> @at 0

  # ### last()
  # Returns the last value in the collection.
  
  last: -> @at @size()-1

  # ### size()
  # Returns the number of items in the collection.

  size: -> @get('models').length

  # ### each(fn)
  # Executes the given function on each item in the collection.
  #
  # Returns the collection for chaining purposes.

  each: (fn) ->
    @get('models').forEach fn
    return @

  # ### map(fn)
  # Executes the given transformation function on each item in the collection.
  # 
  # Returns a new array of values that have been passed through the transformation function.

  map: (fn) -> 
    @get('models').map fn

  # ### filter(fn)
  # Executes the given truth test function on each item in the collection.
  #
  # Returns an array of all the values that pass the truth test.

  filter: (fn) -> 
    @get('models').filter fn

  # ### where(object, raw=false)
  # Iterates through the list and finds each value that contain all of the key-value pairs in object.
  #
  # Specify ```raw=true``` if the items in the collection are [Model](Model.html)s but you do not want to use .get().
  #
  # Returns an array of values that pass the truth test.

  where: (obj, raw) ->
    @filter (item) ->
      for own k,v of obj
        if item instanceof Model and !raw
          return false if item.get(k) isnt v
        else
          return false if item[k] isnt v
      return true

  # ### pluck(attribute, raw=false)
  # Specify ```raw=true``` if the items in the collection are [Model](Model.html)s but you do not want to use .get().
  #
  # Returns an array of values that have been grabbed as properties of each item in the collection.

  pluck: (attr, raw) -> 
    @map (v) ->
      if v instanceof Model and !raw
        return v.get attr
      else
        return v[attr]

  # ### getAll()
  # Returns an array of all items in the collection.
  
  getAll: -> @get 'models'

  # ### fetch(options, callback)
  # See [Syncing documentation](../manual/Syncing.html) for possible options.
  #
  # callback is optional and will be called with ```(error, response)``` if given.
  #
  # Will emit fetching, fetched, and fetchError events.
  #
  # Will use either collection.url or collection.urls.read for request
  #
  # Returns collection for chaining purposes
  
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
      @reset res.body if Array.isArray res.body
      @emit "fetched", res
      cb err, res if cb
    return @

  _processModel: (o) ->
    if @model and !(o instanceof Model)
      mod = new @model o
    else
      mod = o

module.exports = Collection