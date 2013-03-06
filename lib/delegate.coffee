splitEvents = require 'event-splitter'

class Delegate
  _binds: []
  constructor: (@root, @events={}, @context={}) ->

  bindEvent: (event, selector, handler) ->
    handler = @context[handler] if typeof handler is "string"
    $(@root).on event, selector, handler
    @_binds.push [event,selector,handler]
    return @

  unbindEvent: (event, selector, handler) ->
    handler = @context[handler] if typeof handler is "string"
    $(@root).off event, selector, handler
    return @

  bind: ->
    for str, handler of @events
      if typeof handler is 'object'
        for name, evhandler of handler
          @bindEvent name, str, evhandler
      else
        {name, selector} = splitEvents str
        @bindEvent name, selector, handler
    return @

  unbind: ->
    @unbindEvent z... for z in @_binds
    @_binds = []
    return @
    

module.exports = Delegate