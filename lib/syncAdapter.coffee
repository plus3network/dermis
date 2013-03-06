request = require 'superagent'
util = require './util'

methods =
  'create': 'post',
  'update': 'put',
  'patch': 'patch',
  'destroy': 'del',
  'read': 'get'

module.exports = (method, mod, opt={}, cb) ->
  if typeof opt is 'function' and !cb
    cb = opt
    opt = {}

  # Get HTTP Verb
  throw new Error "Invalid method" unless methods[method]?
  verb = methods[method]

  # Get URL
  if mod.urls?
    urls = util.result mod.urls, mod
    url = util.result urls[method], mod
  else if mod.url?
    url = util.result mod.url, mod
  throw new Error "Missing url" unless typeof url is 'string'

  # Defaults
  opt.type ?= 'json'

  req = request[verb](url)
    .type(util.result(opt.type))

  # add in user options to req
  if opt.headers
    req.set util.result opt.headers

  if opt.query
    req.query util.result opt.query

  if opt.username and opt.password
    req.auth util.result(opt.username), util.result(opt.password)

  if util.result(opt.withCredentials) is true
    req.withCredentials()

  unless verb is "GET"
    req.send util.result(opt.attrs) or mod.toJSON()

  req.end cb