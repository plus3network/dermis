Emitter = require 'emitter'
View = require './View'
Region = require './Region'
util = require './util'

# # Layout
# A Layout is an extension on top of a View that abstracts away the complexity of managing sub-views.
#
# Each Layout is a set of [Regions](Region.html) that can have views assigned to them.
#
# See [the Region documentation](Region.html) for Region-related controls.

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
    @_regions[name] = new Region

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