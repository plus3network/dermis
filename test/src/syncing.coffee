should = chai.should()

describe "syncing", ->
  describe "create", ->
    it "should POST with data", (done) ->
      fakeModel = new dermis.Channel
      fakeModel.url = "http://localhost:8888/tests"
      fakeModel.toJSON = ->
        o =
          test: "hello"
        return o

      dermis.sync 'create', fakeModel, (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        should.exist res.body
        res.body.test.should.equal 'hello'
        done()

  describe "read", ->
    it "should GET correctly", (done) ->
      fakeModel = new dermis.Channel
      fakeModel.url = "http://localhost:8888/tests/1"
      fakeModel.toJSON = -> {}

      dermis.sync 'read', fakeModel, (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        should.exist res.body
        res.body.test.should.equal 'hello'
        done()

  describe "update", ->
    it "should PUT correctly", (done) ->
      fakeModel = new dermis.Channel
      fakeModel.url = "http://localhost:8888/tests/1"
      fakeModel.toJSON = ->
        o =
          jarude: "jarude"
        return o

      dermis.sync 'update', fakeModel, (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        should.exist res.body
        should.not.exist res.body.test
        should.exist res.body.jarude
        res.body.jarude.should.equal 'jarude'
        done()

  describe "patch", ->
    it "should PATCH correctly", (done) ->
      return done() if window._phantom # PATCH is broken in phantom?
      fakeModel = new dermis.Channel
      fakeModel.url = "http://localhost:8888/tests/1"
      fakeModel.toJSON = ->
        o =
          test: "jarude"
        return o

      dermis.sync 'patch', fakeModel, (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        should.exist res.body
        res.body.test.should.equal 'jarude'
        done()

  describe "destroy", ->
    it "should DEL correctly", (done) ->
      fakeModel = new dermis.Channel
      fakeModel.url = "http://localhost:8888/tests/1"
      fakeModel.toJSON = -> {}

      dermis.sync 'destroy', fakeModel, (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        should.exist res.body
        res.body.test.should.equal 'hello'
        done()

describe "model syncing", ->
  describe "fetch", ->
    it "should work with read url", (done) ->
      class TestModel extends dermis.Model
        urls:
          create: "http://localhost:8888/tests"
          update: "http://localhost:8888/tests/1"
          read: "http://localhost:8888/tests/1"
          patch: "http://localhost:8888/tests/1"
          destroy: "http://localhost:8888/tests/1"

      syncing = false
      synced = false
      mod = new TestModel
      mod.on "fetching", (opt) ->
        should.exist opt
        syncing = true
      mod.on "fetched", (res) -> 
        should.exist res
        synced = true
      mod.fetch (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.get("test").should.equal "hello"
        syncing.should.equal true
        synced.should.equal true
        done()

    it "should work with single url", (done) ->
      class TestModel extends dermis.Model
        url: "http://localhost:8888/tests/1"

      syncing = false
      synced = false
      mod = new TestModel
      mod.on "fetching", (opt) ->
        should.exist opt
        syncing = true
      mod.on "fetched", (res) -> 
        should.exist res
        synced = true
      mod.fetch (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.get("test").should.equal "hello"
        syncing.should.equal true
        synced.should.equal true
        done()

  describe "save", ->
    it "should work with save url", (done) ->
      class TestModel extends dermis.Model
        urls:
          create: "http://localhost:8888/tests"
          update: "http://localhost:8888/tests/1"
          read: "http://localhost:8888/tests/1"
          patch: "http://localhost:8888/tests/1"
          destroy: "http://localhost:8888/tests/1"

      syncing = false
      synced = false
      mod = new TestModel
      mod.set "test", "hello"

      mod.on "saving", (opt) ->
        should.exist opt
        syncing = true
      mod.on "saved", (res) -> 
        should.exist res
        synced = true
      mod.save (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.get("test").should.equal "hello"
        syncing.should.equal true
        synced.should.equal true
        done()

    it "should work with single url", (done) ->
      class TestModel extends dermis.Model
        url: "http://localhost:8888/tests/1"

      syncing = false
      synced = false
      mod = new TestModel
      mod.set "test", "hello"

      mod.on "saving", (opt) ->
        should.exist opt
        syncing = true
      mod.on "saved", (res) -> 
        should.exist res
        synced = true
      mod.save (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.get("test").should.equal "hello"
        syncing.should.equal true
        synced.should.equal true
        done()

  describe "create", ->
    it "should work with create url", (done) ->
      class TestModel extends dermis.Model
        urls: ->
          read: "http://localhost:8888/tests/1"
          save: "http://localhost:8888/tests/1"
          destroy: "http://localhost:8888/tests/1"
          create: "http://localhost:8888/tests"

      syncing = false
      synced = false
      mod = new TestModel
      mod.set "test", "hello"
      
      mod.on "creating", (opt) ->
        should.exist opt
        syncing = true
      mod.on "created", (res) -> 
        should.exist res
        synced = true
      mod.create (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.get("test").should.equal "hello"
        syncing.should.equal true
        synced.should.equal true
        done()

    it "should work with single url", (done) ->
      class TestModel extends dermis.Model
        url: "http://localhost:8888/tests"

      syncing = false
      synced = false
      mod = new TestModel
      mod.set "test", "hello"

      mod.on "creating", (opt) ->
        should.exist opt
        syncing = true
      mod.on "created", (res) ->
        should.exist res
        synced = true
      mod.create (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.get("test").should.equal "hello"
        syncing.should.equal true
        synced.should.equal true
        done()

  describe "destroy", ->
    it "should work with destroy url", (done) ->
      class TestModel extends dermis.Model
        urls: ->
          read: -> "http://localhost:8888/tests/1"
          save: -> "http://localhost:8888/tests/1"
          destroy: -> "http://localhost:8888/tests/1"
          create: -> "http://localhost:8888/tests"

      syncing = false
      synced = false
      mod = new TestModel
      mod.set "test", "hello"
      
      mod.on "destroying", (opt) ->
        should.exist opt
        syncing = true
      mod.on "destroyed", (res) ->
        should.exist res
        synced = true
      mod.destroy (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.get("test").should.equal "hello"
        syncing.should.equal true
        synced.should.equal true
        done()

    it "should work with single url", (done) ->
      class TestModel extends dermis.Model
        url: -> "http://localhost:8888/tests/1"

      syncing = false
      synced = false
      mod = new TestModel
      mod.set "test", "hello"

      mod.on "destroying", (opt) ->
        should.exist opt
        syncing = true
      mod.on "destroyed", -> synced = true
      mod.destroy (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.get("test").should.equal "hello"
        syncing.should.equal true
        synced.should.equal true
        done()

describe "collection syncing", ->
  describe "fetch", ->
    it "should work with read url", (done) ->
      class TestSet extends dermis.Collection
        urls:
          read: "http://localhost:8888/tests"

      syncing = false
      synced = false
      mod = new TestSet
      mod.on "fetching", (opt) ->
        should.exist opt
        syncing = true
      mod.on "fetched", (res) -> 
        should.exist res
        synced = true
      mod.fetch (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.at(0).test.should.equal "hello"
        mod.at(1).test.should.equal "world"
        syncing.should.equal true
        synced.should.equal true
        done()

    it "should work with single url", (done) ->
      class TestSet extends dermis.Collection
        url: "http://localhost:8888/tests"

      syncing = false
      synced = false
      mod = new TestSet
      mod.on "fetching", (opt) ->
        should.exist opt
        syncing = true
      mod.on "fetched", (res) -> 
        should.exist res
        synced = true
      mod.fetch (err, res) ->
        should.not.exist err
        should.exist res
        res.status.should.equal 200
        mod.at(0).test.should.equal "hello"
        mod.at(1).test.should.equal "world"
        syncing.should.equal true
        synced.should.equal true
        done()