Router = require './Router'
Channel = require './Channel'
rivetsConfig = require './rivetsConfig'
rivets = require 'rivets'

rivets.configure rivetsConfig
rivets.formatters[k]=v for k,v of rivetsConfig.formatters

dermis =
  Layout: require './Layout'
  Region: require './Region'

  Model: require './Model'
  Collection: require './Collection'

  View: require './View'

  Channel: Channel
  Router: Router
  router: new Router
  channel: new Channel
  
  binding: rivets

  sync: require './syncAdapter'
  http: require 'superagent'

  nextTick: (fn) -> setTimeout fn, 0
  internal:
    bindingConfig: rivetsConfig
    makeElement: require './makeElement'
    Delegate: require './delegate'
    util: require './util'
  
module.exports = dermis