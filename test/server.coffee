express = require 'express'
{join} = require 'path'

CORS = (req, res, next) ->
  if req.method is 'OPTIONS'
    res.header 'Access-Control-Allow-Origin', '*'
    res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS'
    res.header 'Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With'
    res.send 200
    return
  next()

app = express()
app.use CORS
app.use express.methodOverride()
app.use express.json()

create = (req, res, next) ->
  res.send 200, req.body

getAll = (req, res, next) ->
  res.send 200, [{test: "hello"}, {test: "world"}]

app.post '/tests', create
app.get '/tests', getAll

get = (req, res, next) ->
  res.send 200, test: "hello"

patch = (req, res, next) ->
  o = test: "hello"
  o[k]=v for k,v of req.body
  res.send 200, o

put = (req, res, next) ->
  res.send 200, req.body

del = (req, res, next) ->
  res.send 200, test: "hello"

app.get '/tests/:id', get
app.put '/tests/:id', put
app.patch '/tests/:id', patch
app.del '/tests/:id', del

app.use express.static join __dirname, '../'

app.listen 8888

console.log "Test server listening"