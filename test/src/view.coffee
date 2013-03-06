should = chai.should()

describe "view", ->
  it 'should be able to make new views', (done) ->
    class TestView extends dermis.View
    should.exist TestView

    vu = new TestView
    should.exist vu
    done()

  it 'should call initialize on construct', (done) ->
    class TestView extends dermis.View
      initialize: (a, b, c) ->
        should.exist a
        should.exist b
        should.exist c
        a.should.equal 1
        b.should.equal 2
        c.should.equal 3
        done()
        return @

    should.exist TestView

    vu = new TestView 1, 2, 3

  it 'should mixin options', (done) ->
    class TestView extends dermis.View
      options:
        a: 1
      initialize: ->
        @options.should.eql
          a: 1
          b: 2
          c: 3
        done()
        return @

    vu = new TestView b: 2, c: 3

  it 'should be able to render with args', (done) ->
    class TestView extends dermis.View
      render: ({id}) ->
        should.exist id
        id.should.equal 1

        should.exist @$el
        @$el.html "test"
        return @

    vu = new TestView
    el = vu.render({id:1}).el
    $(el).html().should.equal "test"
    done()

  it 'should be able to render with preset el', (done) ->
    class TestView extends dermis.View
      el: "#sandbox"

    vu = new TestView
    el = $ vu.render().el
    el.attr('id').should.equal "sandbox"
    done()

  it 'should be able to render with new attrs', (done) ->
    class TestView extends dermis.View
      id: "nada"
      content: "test"
      tagName: 'li'
      className: 'item'
      attributes:
        "height": "250px"

    vu = new TestView
    el = $ vu.render().el
    el.html().should.equal "test"
    el.attr("id").should.equal "nada"
    el.attr("class").should.equal "item"
    el.attr("height").should.equal "250px"
    el.prop("tagName").should.equal "LI"
    done()

  it 'should be able to render with new attrs as functions', (done) ->
    class TestView extends dermis.View
      id: -> "nada"
      content: -> "test"
      tagName: -> 'li'
      className: -> 'item'
      attributes: ->
        "height": "250px"

    vu = new TestView
    el = $ vu.render().el
    el.html().should.equal "test"
    el.attr("id").should.equal "nada"
    el.attr("class").should.equal "item"
    el.attr("height").should.equal "250px"
    el.prop("tagName").should.equal "LI"
    done()

  it 'should have $.find sugar', (done) ->
    class TestView extends dermis.View
      render: ->
        should.exist @$el
        @$el.html '<p id="jarude">test</p>'
        should.exist @$
        @$("#jarude").html().should.equal "test"
        return @

    vu = new TestView
    el = vu.render().el
    should.exist el
    $(el).html().should.equal '<p id="jarude">test</p>'
    done()

describe "view events", ->

  it 'should be able to bind events with args as string', (done) ->
    class TestView extends dermis.View
      events:
        "click .btn": "onClick"
        "dblclick .btn": "wrongEvent"

      wrongEvent: ->
        throw new Error "Wrong event thrown"

      onClick: (e) ->
        should.exist e
        done()
        
      render: ->
        @$el.html "<button class='btn'>Click Me</button>"
        return @

    vu = new TestView
    el = $ vu.render().el
    el.find(".btn").click()

  it 'should be able to bind events with args as function', (done) ->
    class TestView extends dermis.View
      events:
        "click .btn": (e) ->
          should.exist e
          done()

        "dblclick .btn": ->
          throw new Error "Wrong event thrown"
        
      render: ->
        @$el.html "<button class='btn'>Click Me</button>"
        return @

    vu = new TestView
    el = $ vu.render().el
    el.find(".btn").click()

  it 'should be able to bind events with args as object and string', (done) ->
    class TestView extends dermis.View
      events:
        ".btn": 
          "click": "onClick"
          "dblclick": "wrongEvent"
      
      wrongEvent: ->
        throw new Error "Wrong event thrown"

      onClick: (e) ->
        should.exist e
        done()

      render: ->
        @$el.html "<button class='btn'>Click Me</button>"
        return @

    vu = new TestView
    el = $ vu.render().el
    el.find(".btn").click()

  it 'should be able to bind events with args as object and function', (done) ->
    class TestView extends dermis.View
      events:
        ".btn":
          "dblclick": -> throw new Error "Wrong event thrown"
          "click": (e) ->
            should.exist e
            done()
        
      render: ->
        @$el.html "<button class='btn'>Click Me</button>"
        return @

    vu = new TestView
    el = $ vu.render().el
    el.find(".btn").click()

  it 'should be able to unbind events', (done) ->
    class TestView extends dermis.View
      events:
        "click .btn": "onClick"

      onClick: (e) ->
        throw new Error "click event happened!"
        
      render: ->
        @$el.html "<button class='btn'>Click Me</button>"
        return @

    vu = new TestView
    btn = vu.render().$('.btn')
    vu.undelegateEvents()
    btn.click()
    btn.click()
    btn.click()
    done()

  it 'should be able to rebind events without double-calling', (done) ->
    class TestView extends dermis.View
      events:
        "click .btn": "onClick"

      onClick: (e) ->
        should.exist e
        done()
        
        
      render: ->
        @$el.html "<button class='btn'>Click Me</button>"
        return @

    vu = new TestView
    btn = vu.render().$('.btn')
    vu.delegateEvents()
    btn.click()

  it 'should be able to unbind and bind events', (done) ->
    class TestView extends dermis.View
      events:
        "click .btn": "onClick"

      onClick: (e) ->
        should.exist e
        done()
        
      render: ->
        @$el.html "<button class='btn'>Click Me</button>"
        return @

    vu = new TestView
    btn = vu.render().$('.btn')
    vu.undelegateEvents()
    vu.delegateEvents()
    btn.click()

  it 'should be able to remove', (done) ->
    class TestView extends dermis.View
      events:
        "click .btn": "onClick"

      onClick: (e) ->
        throw new Error "click event happened!"
        
      render: ->
        @$el.html "<button class='btn'>Click Me</button>"
        return @

    vu = new TestView
    btn = vu.render().$('.btn')
    vu.remove()
    btn.click()
    btn.click()
    btn.click()
    done()