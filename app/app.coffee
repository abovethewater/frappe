express = require 'express'
http = require 'http'
app = express()

PORT = 8000
PORT_TEST = PORT + 1

app.configure ->
  app.set 'port', process.env.PORT or PORT
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.static "#{__dirname}/public"
  app.use express.favicon()
  app.use express.logger('dev') unless app.get('env') is 'test'
  app.use express.bodyParser()
  app.use express.methodOverride()
  #app.use express.cookieParser 'your secret here'
  #app.use express.session()
  app.use app.router
  app.use require('stylus').middleware "#{__dirname}/public"

# use custom middleware
require('./middleware')(app)

app.configure "development", ->
  app.use express.errorHandler()
  app.locals.pretty = true

app.configure "test", ->
  app.set 'port', PORT_TEST
  app.disable

app.get '/', (req, res) ->
  res.render 'index', title: 'Hello World!'

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get 'port'} in #{app.settings.env} mode"

module.exports = app
