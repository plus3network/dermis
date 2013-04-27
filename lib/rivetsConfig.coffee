prevent = require 'prevent'

# # Binding Formatters
# dermis provides some default data binding formatters to help you get going as quickly as possible
#
# The functions below can be used as standard rivets formatters and can be used in combination with one another to do crazy things.

cfg =
  preloadData: true
  formatters:
    # ### exists
    # ```data-show="user.name | exists"```
    #
    # Returns true or false if the value exists
    exists: (v) -> v?

    # ### empty
    # ```data-hide="user.friends | empty"```
    #
    # Returns true if the value is non-existent or has a length of zero.
    empty: (v) -> !(v? and v?.length isnt 0)

    # ### date
    # ```data-text="user.birthday | date"```
    #
    # You must include [moment.js](http://momentjs.com/) on your page to use this. It is not bundled.
    #
    # Returns the value date formatted by moment.js
    date: (v) -> moment(v).format 'MMM DD, YYYY'

    # ### money
    # ```data-text="user.accountBalance | money"```
    #
    # You must include [accounting.js](http://josscrowcroft.github.com/accounting.js/) on your page to use this. It is not bundled.
    #
    # Returns the value currency formatted by accounting.js
    money: (v) -> accounting.formatMoney v

    # ### toNumber
    # ```data-value="user.sweetText | toNumber"```
    #
    # Returns the value converted to a number
    toNumber: (v) -> +v

    # ### toString
    # ```data-value="user.sweetNumber | toString"```
    #
    # Returns the value converted to a string
    toString: (v) -> String v

    # ### negate
    # ```data-show="user.badBoy | exists | negate"```
    #
    # Returns the boolean opposite of the value (true=false, false=true)
    negate: (v) -> !v

    # ### is
    # ```data-show="user.name | is John"```
    #
    # Returns true if the value equals the argument
    is: (v,a) -> v is a

    # ### isnt
    # ```data-hide="user.name | isnt John"```
    #
    # Returns true if the value doesn't equal the argument
    isnt: (v,a) -> v isnt a

    # ### gt
    # ```data-show="user.friends | length | gt 5"```
    #
    # Returns true if the value is greater than the argument
    gt: (v,a) -> v > a

    # ### lt
    # ```data-hide="user.friends | length | lt 5"```
    #
    # Returns true if the value is less than the argument
    lt: (v,a) -> v < a

    # ### at
    # ```data-text="user.friends | at 0"```
    #
    # Returns the item at the index specified for values
    at: (v, a) ->
      return v unless v?
      return v[parseInt(a)]

    # ### join
    # ```data-text="user.friends | join ,"```
    #
    # Returns the output of value joined by the argument
    join: (v, a) ->
      return v unless v?
      return v.join a

    # ### split
    # ```data-each-friend="user.friendList | split ,"```
    #
    # Returns an array of value split by the argument
    split: (v, a) ->
      return v unless v?
      return v.split a

    # ### prepend
    # ```data-href="user.name | prepend /users/"```
    #
    # Returns a string of argument + value
    prepend: (v,a...) -> a.join(' ')+v

    # ### append
    # ```data-href="user.name | prepend /users/ | append /messages"```
    #
    # Returns a string of value + argument
    append: (v,a...) -> v+a.join(' ')

    # ### length
    # ```data-text="user.friends | length"```
    #
    # Returns the length of the value
    length: (v) ->
      return v unless v?
      return v.length

    # ### cancelEvent
    # ```data-on-submit="user:save | cancelEvent"```
    #
    # Extremely useful for preventing forms from submitting but can be used to stop all event propagation.
    #
    # Returns a new function wrapping value that stops event propagation.
    cancelEvent: (v) ->
      return v unless v?
      return (e) ->
        prevent e
        v.call @, e
        return false

  adapter:
    subscribe: (obj, kp, cb) ->
      obj.on "change:#{kp}", cb
      return

    unsubscribe: (obj, kp, cb) ->
      obj.removeListener "change:#{kp}", cb
      return

    read: (obj, kp) -> obj.get kp

    publish: (obj, kp, val) ->
      obj.set kp, val
      return

publishers = ["toNumber", "toString"]
for k,v of cfg.formatters when publishers.indexOf(k) isnt -1
  v.publish = v.read = v

module.exports = cfg