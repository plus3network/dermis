// Generated by CoffeeScript 1.6.1
var Channel, Router, dermis, k, rivets, rivetsConfig, v, _ref;

Router = require('./Router');

Channel = require('./Channel');

rivetsConfig = require('./rivetsConfig');

rivets = require('rivets');

rivets.configure(rivetsConfig);

_ref = rivetsConfig.formatters;
for (k in _ref) {
  v = _ref[k];
  rivets.formatters[k] = v;
}

dermis = {
  Layout: require('./Layout'),
  Region: require('./Region'),
  Model: require('./Model'),
  Collection: require('./Collection'),
  View: require('./View'),
  Channel: Channel,
  Router: Router,
  router: new Router,
  channel: new Channel,
  binding: rivets,
  sync: require('./syncAdapter'),
  http: require('superagent'),
  nextTick: function(fn) {
    return setTimeout(fn, 0);
  },
  internal: {
    bindingConfig: rivetsConfig,
    makeElement: require('./makeElement'),
    Delegate: require('./delegate'),
    util: require('./util')
  }
};

module.exports = dermis;
