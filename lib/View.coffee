Emitter = require 'emitter'
guid = require 'guid'
Delegate = require './delegate'
extend = require 'extend'
makeElement = require './makeElement'
util = require './util'
rivets = require 'rivets'

# # View
# A view is your presentation layer. The general idea is to split your application up into many views and orchestrate the display in the router.
#
# Views provide you with a virtual element to render your UI to ($el) and let the router put it on the page when it is ready.

class View extends Emitter
  # ### constructor(options)
  # Creates a new View
  #
  # options given get mixed into View.options
  #
  # Triggers your initialize function if given.
  #
  # Binds any events given to the virtual element $el

  constructor: (opt={}) ->
    @_id = guid()
    @_configure opt
    @_ensureElement()
    @initialize arguments...
    @eventBindings = new Delegate @$el, @events, @
    @delegateEvents()

  # ### tagName
  # tag for virtual element with
  #
  # Defaults to div

  tagName: 'div'

  # ### id
  # id attribute for the virtual element
  #
  # Defaults to null

  id: null

  # ### className
  # class attribute for the virtual element
  #
  # Defaults to null

  className: null

  # ### attributes
  # object with any additional attributes for the virtual element
  #
  # Defaults to null

  attributes: null

  # ### $(selector)
  # Sugar for finding child elements of the virtual element $el

  $: (sel) -> @$el.find sel

  # ### bind(data)
  # Binds data to the View
  #
  # returns view for chaining purposes

  bind: (data) ->
    rivets.bind @$el, data
    return @

  # ### initialize()
  # User specified function that gets called on construct if defined
  #
  # Returns view for chaining purposes

  initialize: -> @

  # ### render()
  # User specified function where you put your presentation logic.
  #
  # Returns view for chaining purposes

  render: -> @

  # ### dispose()
  # User specified function for disposing of a view.
  #
  # Defaults to just calling undelegateEvents()
  #
  # Returns view for chaining purposes

  dispose: ->
    @undelegateEvents()
    return @

  # ### remove()
  # Calls user specified dispose() and removes the view from the DOM.
  #
  # Returns view for chaining purposes

  remove: ->
    @dispose()
    @$el.remove()
    return @

  # ### setElement(element, delegate=true)
  # Changes the virtual element for the View.
  #
  # Will undelegate events from the old virtual element
  #
  # Will delegate events on the new element if delegate is true
  #
  # Returns view for chaining purposes

  setElement: (el, delegate=true) ->
    @undelegateEvents() if @$el
    @$el = $ el
    [@el] = @$el
    @delegateEvents() if delegate
    return @

  # ### delegateEvents
  # Binds all events given in user specified events object
  #
  # Returns view for chaining purposes

  delegateEvents: ->
    @undelegateEvents()
    @eventBindings.bind()
    return @

  # ### undelegateEvents
  # Unbinds all events given in user specified events object
  #
  # Returns view for chaining purposes

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