$ = dermis.$

class MyModel extends dermis.Model

class AppLayout extends dermis.Layout
  template: -> "<div id='main'></div>"
  regions:
    "main": "#main"

class MyView extends dermis.View
  events:
    "click .item": "changeItem"
    ".item": 
      "dblclick": "changeDbl"

  changeItem: =>
    @$(".item").html "click"

  changeDbl: =>
    dermis.router.show "/test2"

  render: (mod) ->
    @$el.html "<p class='item' data-text='.initial'></p>"
    mod.bind @$el
    return @

class MyView2 extends MyView
  changeItem: =>
    @$(".item").html "click2"

  changeDbl: =>
    @$(".item").html "dblclick2"


# actual shiz
layout = new AppLayout
$('body').html layout.render().el

# dummies
vu = new MyView
vu2 = new MyView2

mod = new MyModel
mod.set 'initial', 'CLICK ME'

mod2 = new MyModel
mod2.set 'initial', 'VU2 CLICK ME'

# start
layout.set 'main', vu
layout.show 'main', mod

dermis.router.add
  "/test2": ->
    layout.set 'main', vu2
    layout.show 'main', mod2

dermis.router.start()