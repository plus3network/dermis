Emitter = require 'emitter'
page = require 'page'

class Router extends Emitter
  add: (route, handler) ->
    if typeof route is 'object'
      @add rt, h for own rt, h of route
      return
    # TODO: support page middleware style somehow
    if Array.isArray handler
      @add route, fn for fn in handler
      return
    handler = @[handler] if typeof handler is 'string'
    page route, handler
    return @

  base: ->
    page.base arguments...
    return @
  show: ->
    page.show arguments...
    return @
  use: ->
    page '*', arguments...
    return @
  start: ->
    page.start arguments...
    return @
  stop: ->
    page.stop arguments...
    return @
  clear: ->
    page.callbacks = []
    return @
    
module.exports = Router