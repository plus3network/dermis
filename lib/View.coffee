Emitter = require 'emitter'
guid = require 'guid'
Delegate = require './delegate'
extend = require 'extend'
makeElement = require './makeElement'
util = require './util'
rivets = require 'rivets'

class View extends Emitter
  constructor: (opt={}) ->
    @_id = guid()
    @_configure opt
    @_ensureElement()
    @initialize arguments...
    @eventBindings = new Delegate @$el, @events, @
    @delegateEvents()

  tagName: 'div'
  $: (sel) -> @$el.find sel

  bind: (data) ->
    rivets.bind @$el, data

  initialize: -> @
  render: -> @
  dispose: ->
    @undelegateEvents()
    return @

  remove: ->
    @dispose()
    @$el.remove()
    return @

  setElement: (el, delegate=true) ->
    @undelegateEvents() if @$el
    @$el = $ el
    [@el] = @$el
    @delegateEvents() if delegate
    return @

  delegateEvents: ->
    @undelegateEvents()
    @eventBindings.bind()
    return @

  undelegateEvents: ->
    @eventBindings.unbind()
    return @

  _configure: (opt) ->
    @options = extend {}, @options, opt
    return @

  _ensureElement: ->
    if @el
      @setElement util.result(@el), false
    else
      attr = extend {}, util.result(@attributes)
      attr.id = util.result(@id) if @id
      attr.class = util.result(@className) if @className
      virt = makeElement util.result(@tagName), attr, util.result(@content)
      @setElement virt, false
    return @


module.exports = View