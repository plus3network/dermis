afterEach (done) ->
  $("#sandbox").html ''
  dermis.router.base ''
  dermis.router.clear()
  $(document).ready -> done()