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

      class Friends extends dermis.Collection
        model: TestModel

      mod = new TestModel
        friends: new Friends [
          name: "Tobias",
          name: "Tobias"
        ]

      mod.set "friends.0.name", "Gobias"
      mod.toJSON().friends.models[0].name.should.equal "Gobias"
      mod.get("friends.0.name").should.equal "Gobias"
      done()

    it "should be able to replace using nested paths with collections", (done) ->
      class TestModel extends dermis.Model

      class Friends extends dermis.Collection
        model: TestModel
        
      mod = new TestModel
        friends: new Friends [
          name: "Tobias",
          name: "Tobias"
        ]

      mod.set "friends.0", name: "Gobias2"
      mod.toJSON().friends.models[0].name.should.equal "Gobias2"
      mod.get('friends').at(0).get('name').should.equal "Gobias2"
      mod.get("friends.0.name").should.equal "Gobias2"
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

  describe "accessors", ->
    it "should be able to add accessors (models)", (done) ->
      called = false

      class TestModel extends dermis.Model
        accessors:
          name:
            set: (v) ->
              v.should.equal "Fido"

            get: -> "Chollo"

      mod = new TestModel

      mod.set "name", "Fido"
      mod.get("name").should.equal "Chollo"
      done()

  describe "toJSON", ->
    it "should be able to list props", (done) ->
      class TestModel extends dermis.Model

      mod = new TestModel wut: 2
      mod.toJSON().should.eql wut: 2
      done()

    it "should be able list props with reasonable nesting", (done) ->
      friends = new dermis.Collection [
        new dermis.Model(name: "tobias"),
        new dermis.Model(name: "gobias")
      ]
      friends.set "type", "best"

      mod = new dermis.Model
        name: "Bob"
        friends: friends

      mod.toJSON().should.eql
        name: "Bob"
        friends:
          type: "best"
          models: [
            name: "tobias"
          ,
            name: "gobias"
          ]

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