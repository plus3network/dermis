should = chai.should()

describe "collection general", ->
  it "should be able to add", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.on "add", (v) ->
      v.should.equal 2
      done()

    mod.add 2

  it "should be able to add multiple", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2, 3]
    mod.toJSON().models.should.eql [2,3]
    done()

  it "should be able to add with casting", (done) ->
    class TestModel extends dermis.Model

    class TestSet extends dermis.Collection
      model: TestModel

    mod = new TestSet
    mod.on "add", (v) ->
      (v instanceof TestModel).should.equal true
      v.get('name').should.equal "Test"
      done()

    mod.add name: "Test"

  it "should be able to add multiple with casting", (done) ->
    class TestModel extends dermis.Model

    class TestSet extends dermis.Collection
      model: TestModel

    mod = new TestSet
    mod.add [{name: "Test"},{name: "Test"}]
    for v in mod.getAll()
      (v instanceof TestModel).should.equal true
      v.get('name').should.equal "Test"
    done()

  it "should be able to remove by value", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3]
    mod.remove 2
    mod.toJSON().models.should.eql [3]
    done()

  it "should be able to remove multiple by value", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3,4]
    mod.remove [2,4]
    mod.toJSON().models.should.eql [3]
    done()

  it "should be able to remove by index", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3]
    mod.removeAt 1
    mod.toJSON().models.should.eql [2]
    done()

  it "should be able to find index by value", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3]
    mod.indexOf(2).should.equal 0
    done()

  it "should be able to find value by index", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3]
    mod.at(0).should.equal 2
    done()

  it "should be able to get first value", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3]
    mod.first().should.equal 2
    done()

  it "should be able to get all values", (done) ->
    class TestModel extends dermis.Model

    class TestSet extends dermis.Collection
      model: TestModel

    mod = new TestSet
    mod.add [{name: "Test"},{name: "Test"}]
    mod.getAll()[0].get('name').should.equal "Test"
    mod.getAll()[1].get('name').should.equal "Test"
    done()

  it "should be able to get all values as JSON", (done) ->
    class TestModel extends dermis.Model

    class TestSet extends dermis.Collection
      model: TestModel

    mod = new TestSet
    mod.add [{name: "Test"},{name: "Test"}]
    mod.toJSON().models[0].name.should.equal "Test"
    mod.toJSON().models[1].name.should.equal "Test"
    done()

  it "should be able to get last value", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3]
    mod.last().should.equal 3
    done()

  it "should be able to get size", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3]
    mod.size().should.equal 2
    done()

  it "should be able to reset", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3,4]
    mod.on "reset", ->
      mod.toJSON().models.should.eql []
      done()
    mod.reset()

  it "should be able to reset with casting", (done) ->
    class TestModel extends dermis.Model
    class TestSet extends dermis.Collection
      model: TestModel
    mod = new TestSet
    mod.add [{name: "bob"}]
    mod.reset [{name: "test"}, {name: "john"}]
    mod.at(0).get('name').should.equal "test"
    mod.at(1).get('name').should.equal "john"
    done()

  it "should be able to reset silently", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3,4]
    mod.on "reset", ->
      throw new Error "emitted"
    mod.reset true
    mod.toJSON().models.should.eql []
    done()

  it "should be able to reset to values", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2,3,4]
    mod.on "reset", ->
      mod.toJSON().models.should.eql [2,3,5]
      done()
    mod.reset [2,3,5]

  it "should be able to reset to values silently", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [2, 3, 4]
    mod.on "reset", ->
      throw new Error "emitted"
    mod.reset [2,3,5], true
    mod.toJSON().models.should.eql [2,3,5]
    done()

  it "should be able to iterate with each", (done) ->
    class TestModel extends dermis.Model

    class TestSet extends dermis.Collection
      model: TestModel

    mod = new TestSet
    mod.add [{name: "Test"},{name: "Test"}]

    count = 0
    mod.each (mod) ->
      mod.get("name").should.equal "Test"
      count++
    count.should.equal 2
    done()

  it "should be able to pluck properties from vanilla", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [{name: "John"},{name: "Adam"}]

    names = mod.pluck 'name'
    names.should.eql ["John","Adam"]
    done()

  it "should be able to pluck properties with casting", (done) ->
    class TestModel extends dermis.Model

    class TestSet extends dermis.Collection
      model: TestModel

    mod = new TestSet
    mod.add [{name: "John"},{name: "Adam"}]

    names = mod.pluck 'name'
    names.should.eql ["John","Adam"]
    done()

  it "should be able to pluck properties with casting and raw setting", (done) ->
    class TestModel extends dermis.Model

    class TestSet extends dermis.Collection
      model: TestModel

    john = new TestModel
    adam = new TestModel
    john.name = "John"
    adam.name = "Adam"
    mod = new TestSet
    mod.add [john, adam]

    names = mod.pluck 'name', true
    names.should.eql ["John","Adam"]
    done()

  it "should be able to where properties from vanilla", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [{name: "John"},{name: "Adam"}]

    people = mod.where name: "John"
    people.should.eql [mod.at(0)]
    done()

  it "should be able to where properties with casting", (done) ->
    class TestModel extends dermis.Model

    class TestSet extends dermis.Collection
      model: TestModel

    mod = new TestSet
    mod.add [{name: "John"},{name: "Adam"}]

    people = mod.where name: "John"
    people.should.eql [mod.at(0)]
    done()

  it "should be able to where properties with casting and raw setting", (done) ->
    class TestModel extends dermis.Model

    class TestSet extends dermis.Collection
      model: TestModel

    john = new TestModel
    adam = new TestModel
    john.name = "John"
    adam.name = "Adam"
    mod = new TestSet
    mod.add [john, adam]

    people = mod.where {name:"John"}, true
    people.should.eql [john]
    done()

  it "should be able to filter items", (done) ->
    class TestSet extends dermis.Collection

    mod = new TestSet
    mod.add [{name: "John"},{name: "Adam"}]

    people = mod.filter (v) ->
      return v.name is "John"

    people.should.eql [mod.at(0)]
    done()