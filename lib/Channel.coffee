Emitter = require 'emitter'

# # Channel
# This is just a simple EventEmitter.
#
# You can use this to pass messages between different components in your application.
#
# There is a main Channel instance exposed as dermis.channel for convenience but you can create your own with ```new dermis.Channel()```.
#
#
# For details on EventEmitters see [the node.js documentation](http://nodejs.org/api/events.html#events_class_events_eventemitter)

class Channel extends Emitter

module.exports = Channel