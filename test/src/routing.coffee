should = chai.should()

describe "routing", ->
  return unless window._phantom
  it "should trigger routes with qs", (done) ->
    dermis.router.add "/test", (ctx) ->
      should.exist ctx
      should.exist ctx.querystring
      ctx.querystring.should.equal "test=1"
      done()

    dermis.router.show "/test?test=1"

  it "should trigger routes with params", (done) ->
    dermis.router.add "/user/:id/:action", (ctx) ->
      should.exist ctx
      should.exist ctx.params
      ctx.params.id.should.equal "eric"
      ctx.params.action.should.equal "edit"
      done()

    dermis.router.show "/user/eric/edit"

  it "should not trigger routes when stopped", (done) ->
    dermis.router.add "/user/:id/:action", (ctx) ->
      throw new Error "route called"

    dermis.router.stop()
    window.location.href = "#/user/eric/edit"
    done()

  it "should not trigger routes when it doesnt match", (done) ->
    dermis.router.add "/user/:id/:action", (ctx) ->
      throw new Error "route called"

    dermis.router.show "/user/eric"
    done()

  it "should trigger routes when restarted", (done) ->
    dermis.router.add "/user/:id/:action", (ctx) ->
      should.exist ctx
      should.exist ctx.params
      ctx.params.id.should.equal "eric"
      ctx.params.action.should.equal "edit"
      done()

    dermis.router.stop()
    dermis.router.start()
    window.location.href = "#/user/eric/edit"

  it "should accept objects of routes", (done) ->
    dermis.router.add 
      "/user/:id/:action": (ctx) ->
        should.exist ctx
        should.exist ctx.params
        ctx.params.id.should.equal "eric"
        ctx.params.action.should.equal "edit"
        done()

    dermis.router.show "/user/eric/edit"

  it "should accept local routes", (done) ->
    dermis.router.handleRoute = (ctx) ->
        should.exist ctx
        should.exist ctx.params
        ctx.params.id.should.equal "eric"
        ctx.params.action.should.equal "edit"
        done()

    dermis.router.add 
      "/user/:id/:action": "handleRoute"

    dermis.router.show "/user/eric/edit"

  it "should accept array of routes", (done) ->
    fns = []
    fns.push (ctx, next) ->
      should.exist ctx
      should.exist ctx.params
      ctx.params.id.should.equal "eric"
      ctx.params.action.should.equal "edit"
      next()

    fns.push (ctx, next) ->
      should.exist ctx
      should.exist ctx.params
      ctx.params.id.should.equal "eric"
      ctx.params.action.should.equal "edit"
      done()

    dermis.router.add "/user/:id/:action", fns

    dermis.router.show "/user/eric/edit"

  it "should trigger routes with params and pre-middleware", (done) ->
    dermis.router.use (ctx, next) ->
      ctx.params.id = "contra"
      next()

    dermis.router.add "/user/:id/:action", (ctx) ->
      should.exist ctx
      should.exist ctx.params
      ctx.params.id.should.equal "contra"
      ctx.params.action.should.equal "edit"
      done()

    dermis.router.show "/user/eric/edit"

  it "should trigger routes with params and post-middleware", (done) ->
    dermis.router.add "/user/:id/:action", (ctx, next) ->
      should.exist ctx
      should.exist ctx.params
      ctx.params.id.should.equal "eric"
      ctx.params.action.should.equal "edit"
      ctx.params.id = "contra"
      next()

    dermis.router.use (ctx, next) ->
      ctx.params.id.should.equal "contra"
      done()

    dermis.router.show "/user/eric/edit"


  it "should trigger routes with changed base path", (done) ->
    dermis.router.add "/user/:id/:action", (ctx) ->
      should.exist ctx
      should.exist ctx.params
      ctx.params.id.should.equal "eric"
      ctx.params.action.should.equal "edit"
      done()

    dermis.router.base '/wat'
    dermis.router.show "/wat/user/eric/edit"
