Emitter = require 'emitter'
View = require './View'
util = require './util'

# # Layout
# A Layout is an extension on top of a View that abstracts away the complexity of managing sub-views.

class Layout extends View
  constructor: ->
    @_regions = {}
    @regions ?= {} # user defined regions
    @views ?= {} # user defined presets for regions
    super

  # ### region(name)
  # Returns the Region with the given name

  region: (name) -> @_regions[name]

  # ### addRegion(name)
  # Creates a Region with the given name
  #
  # Returns the created Region

  addRegion: (name) =>
    @_regions[name] =
      view: null
      $el: null
      show: (a...) =>
        reg = @_regions[name]
        if reg.view
          reg.clear()
          vu = reg.view
          vu.setElement vu.el
          reg.$el.html vu.render(a...).el
          @emit "show:#{name}"
          @emit "show", name
        return reg

      set: (nu) =>
        reg = @_regions[name]
        reg.view = nu
        @emit "change:#{name}", nu
        @emit "change", name, nu
        return reg

      clear: =>
        reg = @_regions[name]
        if reg.view
          reg.view.remove()
          @emit "clear:#{name}"
          @emit "clear", name
        return reg

  # ### render()
  # Loads regions and wires them up to the Layout's ```.el```
  #
  # Example:
  #
  #     $('body').html(appLayout.render().el)
  #
  # Returns the Layout for chaining purposes
  render: ->
    super
    for name, select of @regions
      @addRegion name
      @region(name).$el = @$ select

    for name, v of @views
      @region(name).view = v

    @emit "render", @
    return @

module.exports = Layout