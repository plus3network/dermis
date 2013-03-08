Emitter = require 'emitter'

# # Region
# A Region is used within a [Layout](Layout.html) to encapsulate state for a section of the page.

class Region extends Emitter
  # ### view
  # The [View](View.html) currently assigned to the region
  view: null
  # ### $el
  # The jQuery element currently assigned to the region
  $el: null

  # ### .show(args)
  # Sets the html for the region to ```.view.el``` after calling ```.view.render()``` with the provided args.
  #
  # Emits a ```show``` event
  #
  # Returns the Region for chaining purposes 
  show: (a...) =>
    if @view
      @clear()
      @view.setElement @view.el
      @$el.html @view.render(a...).el
      @emit "show"
    return @

  # ### .set(view)
  # Sets to ```.view``` to the provided value
  #
  # Emits a ```change``` event with the new view
  #
  # Returns the Region for chaining purposes 
  set: (nu) =>
    @view = nu
    @emit "change", nu
    return @

  # ### .clear()
  # Calls ```.view.remove()``` which undelegates events and removes the [View](View.html) from the DOM.
  #
  # Emits a ```clear``` event
  #
  # Returns the Region for chaining purposes 
  clear: =>
    if @view
      @view.remove()
      @emit "clear"
    return @

module.exports = Region