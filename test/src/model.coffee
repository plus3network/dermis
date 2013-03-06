should = chai.should()

describe "model", ->
  it "should be able to set", (done) ->
    class TestModel extends dermis.Model

    mod = new TestModel
    mod.on "change:wut", (v) ->
      v.should.equal 2
      done()

    mod.set "wut", 2

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

  it "should be able to list props via toJSON", (done) ->
    class TestModel extends dermis.Model

    mod = new TestModel wut: 2
    mod.toJSON().should.eql wut: 2
    done()

  it "should be able to set then has", (done) ->
    class TestModel extends dermis.Model

    mod = new TestModel wut: 2
    mod.has("wut").should.equal true
    done()

  it "should be able to clear props via clear", (done) ->
    class TestModel extends dermis.Model

    mod = new TestModel wut: 2
    mod.toJSON().should.eql wut: 2
    mod.clear()
    mod.toJSON().should.eql {}
    done()