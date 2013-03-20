should = chai.should()

describe "model", ->
  describe "defaults", ->
    it "should be able to specify defaults", (done) ->
      class Pet extends dermis.Model

      class TestModel extends dermis.Model
        defaults:
          dog:
            name: "Fido"

          name: "Test"

      mod = new TestModel
      mod.get('dog').name.should.equal "Fido"
      mod.get('name').should.equal "Test"
      done()

    it "should be able to specify defaults then override via constructor", (done) ->
      class Pet extends dermis.Model

      class TestModel extends dermis.Model
        defaults:
          dog:
            name: "Fido"

          name: "Test"

      mod = new TestModel name: "Tom"
      mod.get('dog').name.should.equal "Fido"
      mod.get('name').should.equal "Tom"
      done()

  describe "setting", ->
    it "should be able to set", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel
      mod.on "change:wut", (v) ->
        v.should.equal 2
        done()

      mod.set "wut", 2

    it "should be able to set using nested paths", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel
        wut: new TestModel(wut: new TestModel(name: "Tobias"))

      mod.set "wut.wut.name", "Gobias"
      mod.toJSON().wut.wut.name.should.equal "Gobias"
      mod.get("wut.wut.name").should.equal "Gobias"
      done()

    it "should be able to set using nested paths with arrays", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel
        friends: [new TestModel(name: "Tobias"), new TestModel(name: "Tobias")]

      mod.set "friends.0.name", "Gobias"
      mod.toJSON().friends[0].name.should.equal "Gobias"
      mod.get("friends.0.name").should.equal "Gobias"
      done()

    it "should be able to set using nested paths with collections", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel
        friends: new dermis.Collection [
          new TestModel(name: "Tobias"),
          new TestModel(name: "Tobias")
        ]

      mod.set "friends.0.name", "Gobias"
      mod.toJSON().friends[0].name.should.equal "Gobias"
      mod.get("friends.0.name").should.equal "Gobias"
      done()

    it "should be able to set silently", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel
      mod.on "change:wut", (v) ->
        throw new Error "Change event called"

      mod.set "wut", 2, true
      done()

    it "should be able to set via constructor", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel wut: 2
      mod.get("wut").should.equal 2
      done()

    it "should be able to set by object", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel
      mod.on "change:wut", (v) ->
        v.should.equal 2
        done()

      mod.set wut: 2

    it "should be able to set by object silently", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel
      mod.on "change:wut", (v) ->
        throw new Error "Change event called"

      mod.set {wut: 2}, true
      done()

    it "should be able to set then has", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel wut: 2
      mod.has("wut").should.equal true
      done()

  describe "casting", ->
    it "should be able to set with casting (models)", (done) ->
      class Pet extends dermis.Model

      class TestModel extends dermis.Model
        casts:
          dog: Pet

      mod = new TestModel
      mod.on "change:dog", (v) ->
        (v instanceof Pet).should.equal true
        v.get('name').should.equal "Fido"
        done()

      mod.set "dog", name: "Fido"

    it "should be able to set with casting (functions)", (done) ->
      class Pet extends dermis.Model

      class TestModel extends dermis.Model
        casts:
          dog: (v) -> new Pet v

      mod = new TestModel
      mod.on "change:dog", (v) ->
        (v instanceof Pet).should.equal true
        v.get('name').should.equal "Fido"
        done()

      mod.set "dog", name: "Fido"

  describe "toJSON", ->
    it "should be able to list props", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel wut: 2
      mod.toJSON().should.eql wut: 2
      done()

    it "should be able to list props with heavy nesting", (done) ->
      class TestModel extends dermis.Model
        casts:
          friends: Friends

      class Friends extends dermis.Collection
        model: TestModel

      robias = new TestModel(name: "Robias", friends: [new TestModel(name:"Gobias")])

      mod = new TestModel
        name: "Gobias"
        bestFriend: robias
        friends: [
          robias,
          new TestModel(name: "Fobias")
        ]

      mod.toJSON().should.eql
        name: "Gobias"
        bestFriend:
          name: "Robias"
          friends: [
            name: "Gobias"
          ]

        friends: [
          name: "Robias"
          friends: [
            name: "Gobias"
          ]
        ,
          name: "Fobias"
        ]
      done()

  describe "clear", ->
    it "should be able to clear props via clear", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel wut: 2
      mod.toJSON().should.eql wut: 2
      mod.clear()
      mod.toJSON().should.eql {}
      done()

  describe "multiple", ->
    it "should be able to set with defaults and casting", (done) ->
      class Pet extends dermis.Model

      class TestModel extends dermis.Model
        casts:
          dog: Pet

        defaults:
          dog:
            name: "Fido"

      mod = new TestModel
      should.exist mod.get('dog')
      (mod.get('dog') instanceof Pet).should.equal true
      mod.get('dog').get('name').should.equal "Fido"
      done()