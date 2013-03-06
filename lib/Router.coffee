Emitter = require 'emitter'
page = require 'page'

# # Router
# A Router is used to control application state via URL routes.
#
# There is a main Router instance exposed as dermis.router for convenience but you can create your own with ```new dermis.Router()```.


class Router extends Emitter
  # ### add (route, handler)
  # Adds a route listener for the specified route with the specified handler
  # route can either be a string (path) or object of routes where key is string (path) and value is handler
  #
  # handler can either be a function, a string function name of a function that exists on the router, or an array of either.
  #
  # Example:
  #
  #     router.add '/user/:id/messages/:msgid', (ctx) ->
  #         ctx.params.id = "1"
  #         ctx.params.msgid = "123"
  #     window.location.href = "/user/1/messages/123"
  #
  # Returns router for chaining purposes
  add: (route, handler) ->
    if typeof route is 'object'
      @add rt, h for own rt, h of route
      return
    if Array.isArray handler
      @add route, fn for fn in handler
      return
    handler = @[handler] if typeof handler is 'string'
    page route, handler
    return @

  # ### base(newPath)
  # Changes the base path for the router. Useful for isolating concerns between routers by path.
  #
  # Returns router for chaining purposes
  base: ->
    page.base arguments...
    return @

  # ### show(path)
  # Triggers route without changing the URL
  #
  # Returns router for chaining purposes
  show: ->
    page.show arguments...
    return @

  # ### use(handler)
  # Add a middleware step to the router. Equivalent of ```.add('*', handler)```
  #
  # Returns router for chaining purposes

  use: ->
    page '*', arguments...
    return @

  # ### start()
  # Starts listening for click/url events (does this by default on construct)
  #
  # Returns router for chaining purposes
  start: ->
    page.start arguments...
    return @

  # ### stop()
  # Stops listening for click/url events. Does not stop ```.show()``` from triggering routes
  #
  # Returns router for chaining purposes
  stop: ->
    page.stop arguments...
    return @

  # ### clear()
  # Remove all route handlers
  #
  # Returns router for chaining purposes
  clear: ->
    page.callbacks = []
    return @
    
module.exports = Router