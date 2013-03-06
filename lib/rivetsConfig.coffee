cfg =
  preloadData: true
  formatters:
    exists: (v) -> v?
    empty: (v) -> !(v? and v?.length isnt 0)

    date: (v) -> moment(v).format 'MMM DD, YYYY'
    money: (v) -> accounting.formatMoney v

    toNumber: (v) -> +v
    toString: (v) -> String v

    negate: (v) -> !v
    is: (v,a) -> v is a
    isnt: (v,a) -> v isnt a

    gt: (v,a) -> v > a
    lt: (v,a) -> v < a

    at: (v, a) -> v[parseInt(a)]
    join: (v, a) -> v.join a
    split: (v, a) -> v.split a
    prepend: (v,a) -> a+v
    append: (v,a) -> v+a
    length: (v) -> v.length
    cancelEvent: (v) ->
      (e) ->
        e.preventDefault()
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