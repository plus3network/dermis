
module.exports = (tagName, attributes, content) ->
  el = document.createElement tagName
  $(el).attr attributes if attributes
  $(el).html content if content
  return el