should = chai.should()

describe "binding formatters", ->
  {formatters} = dermis.internal.bindingConfig
  describe "exists", ->
    it 'should work', (done) ->
      formatters.exists(null).should.equal false
      formatters.exists().should.equal false
      formatters.exists(1).should.equal true
      formatters.exists("jarude").should.equal true
      done()

  describe "empty", ->
    it 'should work with arrays', (done) ->
      formatters.empty([]).should.equal true
      formatters.empty([1]).should.equal false
      done()

    it 'should work with strings', (done) ->
      formatters.empty("").should.equal true
      formatters.empty("jarude").should.equal false
      done()

    it 'should work with other', (done) ->
      formatters.empty(null).should.equal true
      formatters.empty().should.equal true
      formatters.empty(1).should.equal false
      formatters.empty({jarude:true}).should.equal false
      done()

  describe "toNumber", ->
    it 'should work', (done) ->
      formatters.toNumber("1").should.equal 1
      formatters.toNumber("2.35").should.equal 2.35
      done()

  describe "toString", ->
    it 'should work', (done) ->
      formatters.toString(1).should.equal "1"
      formatters.toString(2.35).should.equal "2.35"
      done()

  describe "negate", ->
    it 'should work', (done) ->
      formatters.negate(true).should.equal false
      formatters.negate(false).should.equal true
      done()

  describe "is", ->
    it 'should work', (done) ->
      formatters.is("1","2").should.equal false
      formatters.is("1","1").should.equal true
      done()

  describe "isnt", ->
    it 'should work', (done) ->
      formatters.isnt("1","2").should.equal true
      formatters.isnt("1","1").should.equal false
      done()

  describe "gt", ->
    it 'should work', (done) ->
      formatters.gt(2, 1).should.equal true
      formatters.gt(1, 1).should.equal false
      formatters.gt(0, 1).should.equal false
      done()

  describe "lt", ->
    it 'should work', (done) ->
      formatters.lt(1, 2).should.equal true
      formatters.lt(1, 1).should.equal false
      formatters.lt(1, 0).should.equal false
      done()

  describe "at", ->
    it 'should work', (done) ->
      formatters.at([1,2], 1).should.equal 2
      formatters.at("jah", 0).should.equal "j"
      done()

  describe "length", ->
    it 'should work', (done) ->
      formatters.length("test").should.equal 4
      formatters.length([1,2,3]).should.equal 3
      done()

  describe "join", ->
    it 'should work', (done) ->
      formatters.join([1,2,3,4], ",").should.equal "1,2,3,4"
      done()

  describe "split", ->
    it 'should work', (done) ->
      formatters.split("1,2,3,4", ",").should.eql ["1","2","3","4"]
      done()

  describe "prepend", ->
    it 'should work', (done) ->
      formatters.prepend("world", "hello").should.equal "helloworld"
      formatters.prepend("world", "hello", "cruel").should.equal "hello cruelworld"
      done()

  describe "append", ->
    it 'should work', (done) ->
      formatters.append("hello","world").should.equal "helloworld"
      formatters.append("hello","cruel","world").should.equal "hellocruel world"
      done()

  describe "cancelEvent", ->
    it 'should work', (done) ->
      called = false
      fakeScope = {}
      fakeEvent =
        preventDefault: ->
          called = true

      newFunction = formatters.cancelEvent (e) ->
        should.exist e
        should.exist e.preventDefault
        @.should.equal fakeScope
        called.should.equal true
        done()

      newFunction.call fakeScope, fakeEvent

  describe "sort", ->
    it 'should sort asc by default', (done) ->
      formatters
        .sort([5,3,1,2,4])
        .should
        .eql [1,2,3,4,5]
      done()
    it 'should work with strings', (done) ->
      formatters
        .sort(["Banana", "Orange", "Apple", "Mango"])
        .should
        .eql ["Apple", "Banana", "Mango", "Orange"]
      done()
    it 'should sort asc if specified', (done) ->
      formatters
        .sort([5,3,1,2,4], 'asc')
        .should
        .eql [1,2,3,4,5]
      done()
    it 'should sort desc if specified', (done) ->
      formatters
        .sort([5,3,1,2,4], 'desc')
        .should
        .eql [5,4,3,2,1]
      done()

  describe "sortBy", ->
    it 'should sort asc by default on specified field', (done) ->
      formatters
        .sortBy([
          name: 'Dune'
          date: '12/14/84'
        ,
          name: 'Batman',
          date: '6/23/89']
        , 'name')
        .should
        .eql [
          name: 'Batman',
          date: '6/23/89'
        ,
          name: 'Dune'
          date: '12/14/84']
      done()
    it 'should sort desc when specified', (done) ->
      formatters
        .sortBy([
          name: 'Batman',
          date: '6/23/89'
        ,
          name: 'Dune'
          date: '12/14/84']
        , 'name', 'desc')
        .should
        .eql [
          name: 'Dune'
          date: '12/14/84'
        ,
          name: 'Batman',
          date: '6/23/89']
      done()


describe "binding adapter", ->
  {adapter} = dermis.internal.bindingConfig
  describe "subscribe", ->
    it 'should work with named keypath', (done) ->
      changed = (newVal) ->
        should.exist newVal
        newVal.should.equal "hello"
        done()

      fakeModel = new dermis.Channel
      adapter.subscribe fakeModel, "test", changed

      fakeModel.emit "change:test", "hello"

  describe "unsubscribe", ->
    it 'should work with named keypath', (done) ->
      changed = (newVal) ->
        throw new Error "Called!"

      fakeModel = new dermis.Channel
      adapter.subscribe fakeModel, "test", changed
      adapter.unsubscribe fakeModel, "test", changed
      fakeModel.emit "change:test", "hello"
      done()

  describe "read", ->
    it 'should work with named keypath', (done) ->
      fakeModel = new dermis.Model
      fakeModel.set 'test', 'hello'
      adapter.read(fakeModel, "test").should.equal 'hello'
      done()

  describe "publish", ->
    it 'should work with named keypath', (done) ->
      fakeModel = new dermis.Model
      adapter.publish fakeModel, "test", "hello"
      fakeModel.get('test').should.equal 'hello'
      done()

describe "actual binding", ->
  it 'should be able to bind by model', (done) ->
    fakeModel = new dermis.Model
    fakeModel.set "test", "hello"

    class TestView extends dermis.View
      attributes:
        "data-text": ".test"

    vu = new TestView
    el = $ vu.render().el
    fakeModel.bind el
    el.html().should.equal "hello"
    done()

  it 'should be able to bind by view', (done) ->
    fakeModel = new dermis.Model
    fakeModel.set "test", "hello"

    class TestView extends dermis.View
      attributes:
        "data-text": ".test"

    vu = new TestView
    el = $ vu.render().el
    vu.bind fakeModel
    el.html().should.equal "hello"
    done()

  it 'should be able to bind with collection', (done) ->
    fakeList = new dermis.Collection
    john = new dermis.Model name: "John", score: 100
    tom = new dermis.Model name: "Tom", score: 50
    tim = new dermis.Model name: "Tim", score: 10

    fakeList.add john
    fakeList.add tom

    class TestView extends dermis.View
      tagName: "ul"
      content: """
      <li data-each-user='.models'>
      <p class='username' data-text='user.name'></p>
      <p class='score' data-text='user.score'></p>
      </li>
      """

    vu = new TestView
    el = $ vu.render().el
    vu.bind fakeList
    el.children().length.should.equal 2

    el.children().eq(0).find(".username").html().should.equal "John"
    el.children().eq(0).find(".score").html().should.equal "100"

    el.children().eq(1).find(".username").html().should.equal "Tom"
    el.children().eq(1).find(".score").html().should.equal "50"

    fakeList.at(0).set 'score', 200
    el.children().eq(0).find(".score").html().should.equal "200"

    fakeList.add tim

    el.children().eq(2).find(".username").html().should.equal "Tim"
    el.children().eq(2).find(".score").html().should.equal "10"

    done()

  it 'should be able to bind with collection and nesting', (done) ->
    fakeList = new dermis.Collection
    class Person extends dermis.Model
      casts:
        name: dermis.Model
    john = new Person
      name:
        first: "John"
      score: 100

    tom = new dermis.Model
      name:
        first: "Tom"
      score: 50

    tim = new dermis.Model
      name: 
        first: "Tim"
      score: 10

    fakeList.add john
    fakeList.add tom

    class TestView extends dermis.View
      tagName: "ul"
      content: """
      <li data-each-user='.models'>
      <p class='username' data-text='user.name.first'></p>
      <p class='score' data-text='user.score'></p>
      </li>
      """

    vu = new TestView
    el = $ vu.render().el
    vu.bind fakeList
    el.children().length.should.equal 2

    el.children().eq(0).find(".username").html().should.equal "John"
    el.children().eq(0).find(".score").html().should.equal "100"

    el.children().eq(1).find(".username").html().should.equal "Tom"
    el.children().eq(1).find(".score").html().should.equal "50"

    fakeList.at(0).set 'score', 200
    el.children().eq(0).find(".score").html().should.equal "200"

    fakeList.add tim

    el.children().eq(2).find(".username").html().should.equal "Tim"
    el.children().eq(2).find(".score").html().should.equal "10"

    done()

  it 'should be able to bind with collection and nesting 2', (done) ->
    fakeList = new dermis.Collection
    class Person extends dermis.Model
      casts:
        name: dermis.Model
    john = new Person
      name:
        first: "John"
      score: 100

    tom = new dermis.Model
      name:
        first: "Tom"
      score: 50

    tim = new dermis.Model
      name: 
        first: "Tim"
      score: 10

    fakeList.add john
    fakeList.add tom

    class TestView extends dermis.View
      tagName: "ul"
      content: """
      <li data-each-user='.models'>
      <p class='username' data-text='user.name.first.0'></p>
      <p class='score' data-text='user.score'></p>
      </li>
      """

    vu = new TestView
    el = $ vu.render().el
    vu.bind fakeList
    el.children().length.should.equal 2

    el.children().eq(0).find(".username").html().should.equal "J"
    el.children().eq(0).find(".score").html().should.equal "100"

    el.children().eq(1).find(".username").html().should.equal "T"
    el.children().eq(1).find(".score").html().should.equal "50"

    fakeList.at(0).set 'score', 200
    el.children().eq(0).find(".score").html().should.equal "200"

    fakeList.add tim

    el.children().eq(2).find(".username").html().should.equal "T"
    el.children().eq(2).find(".score").html().should.equal "10"

    done()

  it 'should be able to bind with collection and formatter', (done) ->
    fakeList = new dermis.Collection
    john = new dermis.Model name: "John", score: 100
    tom = new dermis.Model name: "Tom", score: 50
    tim = new dermis.Model name: "Tim", score: 10

    fakeList.add john
    fakeList.add tom

    class TestView extends dermis.View
      tagName: "ul"
      content: """
      <li data-each-user='.models' data-show='user.name | is John'>
      <p class='username' data-text='user.name'></p>
      <p class='score' data-text='user.score'></p>
      </li>
      """

    vu = new TestView
    el = $ vu.render().el
    vu.bind fakeList
    el.children().length.should.equal 2

    el.children().eq(0).find(".username").html().should.equal "John"
    el.children().eq(0).find(".score").html().should.equal "100"

    el.children().eq(1).attr('style').trim().should.equal "display: none;"
    el.children().eq(1).find(".username").html().should.equal "Tom"
    el.children().eq(1).find(".score").html().should.equal "50"

    done()

  it 'should be able to bind with collection and events', (done) ->
    fakeList = new dermis.Collection
    john = new dermis.Model name: "John", score: 1
    tom = new dermis.Model name: "Tom", score: 50

    john.add = ->
      @set 'score', @get('score')+1

    fakeList.add john
    fakeList.add tom

    class TestView extends dermis.View
      tagName: "ul"
      content: """
      <li data-each-user='.models' data-show='user.name'>
      <p class='username' data-text='user.name'></p>
      <p class='score' data-text='user.score' data-on-click='user:add'></p>
      </li>
      """

    vu = new TestView
    el = $ vu.render().el
    vu.bind fakeList
    el.children().length.should.equal 2
    el.children().eq(0).find(".score").html().should.equal "1"
    el.children().eq(0).find(".score").click()
    el.children().eq(0).find(".score").html().should.equal "2"
    done()

  it 'should be able to bind with collection and events that wipe', (done) ->
    fakeList = new dermis.Collection
    john = new dermis.Model name: "John", score: 1
    tom = new dermis.Model name: "Tom", score: 50

    john.wipe = ->
      @remove 'score'

    fakeList.add john
    fakeList.add tom

    class TestView extends dermis.View
      tagName: "ul"
      content: """
      <li data-each-user='.models' data-show='user.name'>
      <p class='username' data-text='user.name'></p>
      <p class='score' data-text='user.score' data-on-click='user:wipe'></p>
      </li>
      """

    vu = new TestView
    el = $ vu.render().el
    vu.bind fakeList
    el.children().length.should.equal 2
    el.children().eq(0).find(".score").html().should.equal "1"
    el.children().eq(0).find(".score").click()
    el.children().eq(0).find(".score").html().should.equal ""
    done()

  it 'should be able to two way bind with collection', (done) ->
    fakeList = new dermis.Collection
    john = new dermis.Model name: "John", score: 1
    tom = new dermis.Model name: "Tom", score: 50

    fakeList.add john
    fakeList.add tom

    class TestView extends dermis.View
      tagName: "ul"
      content: """
      <li data-each-user='.models' data-show='user.name'>
      <p class='username' data-text='user.name'></p>
      <input class='score' data-value='user.score | toNumber'></input>
      </li>
      """

    vu = new TestView
    el = $ vu.render().el
    vu.bind fakeList
    el.children().length.should.equal 2
    el.children().eq(0).find(".score").val().should.equal "1"
    el.children().eq(0).find(".score").val "2"
    el.children().eq(0).find(".score").change()
    el.children().eq(0).find(".score").val().should.equal "2"
    john.get("score").should.equal 2
    done()