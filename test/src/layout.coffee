should = chai.should()

describe "layout", ->
  it 'should be able to make new layouts', (done) ->
    class TestLayout extends dermis.Layout
    should.exist TestLayout

    lay = new TestLayout
    should.exist lay
    done()

  it 'should call initialize on construct', (done) ->
    class TestLayout extends dermis.Layout
      initialize: (a, b, c) ->
        should.exist a
        should.exist b
        should.exist c
        a.should.equal 1
        b.should.equal 2
        c.should.equal 3
        done()
        return @

    should.exist TestLayout

    lay = new TestLayout 1, 2, 3

  it 'should be able to render with args', (done) ->
    class TestLayout extends dermis.Layout
      render: ({id}) ->
        should.exist id
        id.should.equal 1

        should.exist @$el
        @$el.html "test"
        return @

    lay = new TestLayout
    el = lay.render({id:1}).el
    $(el).html().should.equal "test"
    done()

  it 'should be able to render with new attrs', (done) ->
    class TestLayout extends dermis.Layout
      id: "nada"
      content: "test"
      tagName: 'li'
      className: 'item'
      attributes:
        "height": "250px"

    lay = new TestLayout
    el = $ lay.render().el
    el.html().should.equal "test"
    el.attr("id").should.equal "nada"
    el.attr("class").should.equal "item"
    el.attr("height").should.equal "250px"
    el.prop("tagName").should.equal "LI"
    done()

  it 'should be able to render with new attrs as functions', (done) ->
    class TestLayout extends dermis.Layout
      id: -> "nada"
      content: -> "test"
      tagName: -> 'li'
      className: -> 'item'
      attributes: ->
        "height": "250px"

    lay = new TestLayout
    el = $ lay.render().el
    el.html().should.equal "test"
    el.attr("id").should.equal "nada"
    el.attr("class").should.equal "item"
    el.attr("height").should.equal "250px"
    el.prop("tagName").should.equal "LI"
    done()

  it 'should have $.find sugar', (done) ->
    class TestLayout extends dermis.Layout
      render: ->
        should.exist @$el
        @$el.html '<p id="jarude">test</p>'
        should.exist @$
        @$("#jarude").html().should.equal "test"
        return @

    lay = new TestLayout
    el = lay.render().el
    should.exist el
    $(el).html().should.equal '<p id="jarude">test</p>'
    done()

describe "layout children", ->
  it "should be able to define regions", (done) ->
    class TestLayout extends dermis.Layout
      content: "<div class='sidebar'/><div class='content'/>"
      className: 'main-content'

      regions:
        sidebar: ".sidebar"
        content: ".content"

    lay = new TestLayout
    el = $ lay.render().el
    done()

  it "should be able to get regions elements", (done) ->
    class TestLayout extends dermis.Layout
      content: "<div class='sidebar'/><div class='content'/>"
      className: 'main-content'

      regions:
        sidebar: ".sidebar"
        content: ".content"

    lay = new TestLayout
    el = $ lay.render().el
    should.exist lay.region("sidebar").$el
    should.exist lay.region("content").$el
    should.not.exist lay.region("dummy")
    done()

  it "should be able to set regions", (done) ->
    class TestLayout extends dermis.Layout
      content: "<div class='sidebar'/><div class='content'/>"
      className: 'main-content'

      regions:
        sidebar: ".sidebar"
        content: ".content"

    class TestView extends dermis.View
      content: "Hello"

    lay = new TestLayout
    el = $ lay.render().el

    lay.region("sidebar").set new TestView
    lay.region("content").set new TestView
    should.exist lay.region("sidebar").view
    should.exist lay.region("content").view
    done()

  it "should be able to set and show regions", (done) ->
    class TestView extends dermis.View
      content: "Hello"

    class TestLayout extends dermis.Layout
      content: "<div class='sidebar'/><div class='content'/>"
      className: 'main-content'

      regions:
        sidebar: ".sidebar"
        content: ".content"

    lay = new TestLayout
    el = $ lay.render().el

    lay.region("sidebar").set new TestView
    lay.region("content").set new TestView

    should.exist lay.region("sidebar").view
    should.exist lay.region("content").view

    lay.region("sidebar").show()
    lay.region("content").show()

    lay.region("sidebar").$el.html().should.equal "<div>Hello</div>"
    lay.region("content").$el.html().should.equal "<div>Hello</div>"
    done()

  it "should be able to set and show over regions", (done) ->
    class TestView extends dermis.View
      content: "<button id='btn'>Hello</btn>"
      events:
        "click .btn": -> throw "Click fired!"

    class OtherTestView extends dermis.View
      content: "<button id='btn'>Hello 2</btn>"

    class TestLayout extends dermis.Layout
      content: "<div class='sidebar'/><div class='content'/>"
      className: 'main-content'

      regions:
        sidebar: ".sidebar"
        content: ".content"

    lay = new TestLayout
    el = $ lay.render().el

    lay.region("sidebar").set new TestView
    lay.region("content").set new TestView

    should.exist lay.region("sidebar").view
    should.exist lay.region("content").view

    lay.region("sidebar").show()
    lay.region("content").show()

    lay.region("sidebar").$el.html().should.equal '<div><button id="btn">Hello</button></div>'
    lay.region("content").$el.html().should.equal '<div><button id="btn">Hello</button></div>'


    lay.region("sidebar").set new OtherTestView
    lay.region("content").set new OtherTestView

    should.exist lay.region("sidebar").view
    should.exist lay.region("content").view

    lay.region("sidebar").show()
    lay.region("content").show()

    lay.region("sidebar").$el.html().should.equal '<div><button id="btn">Hello 2</button></div>'
    lay.region("content").$el.html().should.equal '<div><button id="btn">Hello 2</button></div>'

    # Test that events for view dont get fired
    lay.region("sidebar").view.$(".btn").click()
    lay.region("content").view.$(".btn").click()

    done()

  it "should be able to preset and show regions", (done) ->
    class TestView extends dermis.View
      content: "Hello"

    class TestLayout extends dermis.Layout
      content: "<div class='sidebar'/><div class='content'/>"
      className: 'main-content'

      regions:
        sidebar: ".sidebar"
        content: ".content"

      views:
        sidebar: new TestView
        content: new TestView

    lay = new TestLayout
    el = $ lay.render().el

    should.exist lay.region("sidebar").view
    should.exist lay.region("content").view

    lay.region("sidebar").show()
    lay.region("content").show()
    
    lay.region("sidebar").$el.html().should.equal "<div>Hello</div>"
    lay.region("content").$el.html().should.equal "<div>Hello</div>"
    done()

  it "should be able to set and show regions with arguments", (done) ->
    class TestLayout extends dermis.Layout
      content: "<div class='sidebar'/><div class='content'/>"
      className: 'main-content'

      regions:
        sidebar: ".sidebar"
        content: ".content"

    class TestView extends dermis.View
      render: ({id}) ->
        @$el.html id
        return @

    lay = new TestLayout
    el = $ lay.render().el

    lay.region("sidebar").set new TestView
    lay.region("content").set new TestView

    should.exist lay.region("sidebar").view
    should.exist lay.region("content").view

    lay.region("sidebar").show id: 1
    lay.region("content").show id: 2

    lay.region("sidebar").$el.html().should.equal "<div>1</div>"
    lay.region("content").$el.html().should.equal "<div>2</div>"
    done()