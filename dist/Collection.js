// Generated by CoffeeScript 1.6.2
var Collection, Emitter, Model, rivets, rivetsConfig,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Emitter = require('emitter');

rivets = require('rivets');

rivetsConfig = require('./rivetsConfig');

Model = require('./Model');

Collection = (function(_super) {
  __extends(Collection, _super);

  Collection._isCollection = true;

  Collection.prototype._isCollection = true;

  function Collection(items) {
    Collection.__super__.constructor.apply(this, arguments);
    if (!this.has('models')) {
      this.set('models', []);
    }
    if (Array.isArray(items)) {
      this.add(items);
    }
  }

  Collection.prototype.model = null;

  Collection.prototype.add = function(o, silent) {
    var i, mod, _i, _len;

    if (Array.isArray(o)) {
      for (_i = 0, _len = o.length; _i < _len; _i++) {
        i = o[_i];
        this.add(i, silent);
      }
      return this;
    }
    mod = this._processModel(o);
    this.get('models').push(mod);
    this.set('models', this.get('models'), silent);
    if (!silent) {
      this.emit("add", mod);
    }
    return this;
  };

  Collection.prototype.remove = function(o, silent) {
    var i, idx, _i, _len;

    if (Array.isArray(o)) {
      for (_i = 0, _len = o.length; _i < _len; _i++) {
        i = o[_i];
        this.remove(i, silent);
      }
      return this;
    }
    idx = this.indexOf(o);
    if (idx !== -1) {
      this.get('models').splice(idx, 1);
      this.set('models', this.get('models'), silent);
      if (!silent) {
        this.emit("remove", o);
      }
    }
    return this;
  };

  Collection.prototype.removeAt = function(idx, silent) {
    return this.remove(this.at(idx), silent);
  };

  Collection.prototype.replace = function(o, nu, silent) {
    var idx;

    idx = this.indexOf(o);
    if (idx !== -1) {
      this.replaceAt(idx, nu, silent);
    }
    return this;
  };

  Collection.prototype.replaceAt = function(idx, nu, silent) {
    var mods;

    mods = this.get('models');
    mods[idx] = this._processModel(nu);
    this.set('models', mods, silent);
    return this;
  };

  Collection.prototype.reset = function(o, silent) {
    if (typeof o === 'boolean') {
      silent = o;
      o = null;
    }
    if (o) {
      this.set('models', [], true);
      this.add(o, silent);
    } else {
      this.set('models', [], silent);
    }
    if (!silent) {
      this.emit("reset");
    }
    return this;
  };

  Collection.prototype.indexOf = function(o) {
    return this.get('models').indexOf(o);
  };

  Collection.prototype.at = function(idx) {
    return this.get('models')[idx];
  };

  Collection.prototype.first = function() {
    return this.at(0);
  };

  Collection.prototype.last = function() {
    return this.at(this.size() - 1);
  };

  Collection.prototype.size = function() {
    return this.get('models').length;
  };

  Collection.prototype.each = function(fn) {
    this.get('models').forEach(fn);
    return this;
  };

  Collection.prototype.map = function(fn) {
    return this.get('models').map(fn);
  };

  Collection.prototype.filter = function(fn) {
    return this.get('models').filter(fn);
  };

  Collection.prototype.where = function(obj, raw) {
    return this.filter(function(item) {
      var k, v;

      for (k in obj) {
        if (!__hasProp.call(obj, k)) continue;
        v = obj[k];
        if (item instanceof Model && !raw) {
          if (item.get(k) !== v) {
            return false;
          }
        } else {
          if (item[k] !== v) {
            return false;
          }
        }
      }
      return true;
    });
  };

  Collection.prototype.pluck = function(attr, raw) {
    return this.map(function(v) {
      if (v instanceof Model && !raw) {
        return v.get(attr);
      } else {
        return v[attr];
      }
    });
  };

  Collection.prototype.getAll = function() {
    return this.get('models');
  };

  Collection.prototype.fetch = function(opt, cb) {
    var _this = this;

    if (typeof opt === 'function' && !cb) {
      cb = opt;
      opt = {};
    }
    this.emit("fetching", opt);
    this.sync('read', this, opt, function(err, res) {
      if (err != null) {
        _this.emit("fetchError", err);
        if (cb) {
          cb(err);
        }
        return;
      }
      if (Array.isArray(res.body)) {
        _this.reset(res.body);
      }
      _this._fetched = true;
      _this.emit("fetched", res);
      if (cb) {
        return cb(err, res);
      }
    });
    return this;
  };

  Collection.prototype._processModel = function(o) {
    var mod;

    if (this.model && !(o instanceof Model)) {
      mod = new this.model(o);
    } else {
      mod = o;
    }
    return mod;
  };

  return Collection;

})(Model);

module.exports = Collection;