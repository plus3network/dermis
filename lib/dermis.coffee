Router = require './Router'
Channel = require './Channel'
rivetsConfig = require './rivetsConfig'
rivets = require 'rivets'

rivets.configure rivetsConfig
rivets.formatters[k]=v for k,v of rivetsConfig.formatters

dermis =
  Layout: require './Layout'
  Model: require './Model'
  View: require './View'
  Collection: require './Collection'
  Channel: Channel
  Router: Router
  Emitter: require 'emitter'
  binding: rivets
  sync: require './syncAdapter'
  router: new Router
  channel: new Channel
  http: require 'superagent'

  internal:
    bindingConfig: rivetsConfig
    makeElement: require './makeElement'
    Delegate: require './delegate'
    util: require './util'
  
module.exports = dermis