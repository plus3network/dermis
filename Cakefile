flour = require 'flour'
cp = require 'child_process'

task 'watch', ->
  invoke 'test'
  
  watch 'lib/', -> 
    invoke 'test'

  watch 'test/src/', -> 
    invoke 'test'

  watch 'test/server.coffee', -> 
    invoke 'test'

  watch 'test/runner.html', -> 
    invoke 'test'

task 'test', ->
  cp.spawn 'make', ['test'], stdio: 'inherit'