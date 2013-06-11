{inspect} = require 'util'
net      = require 'net'
Stream   = require 'stream'
spawn    = require('child_process').spawn

execSync = require 'execSync'
buffy    = require 'buffy'

sexp     = require './s-expression'

pretty = (obj) -> "#{inspect obj, no, 20, yes}"

isArray     = (obj) -> Array.isArray obj
isString    = (obj) -> !!(obj is '' or (obj and obj.charCodeAt and obj.substr))


class exports.Client extends Stream

  constructor: (options={}) ->
    super @
    @host = options.host ? 'localhost'
    @port = options.port ? 3100

    @client = net.connect @port, @host

    @client.on 'error',   (er) => @emit 'error', er
    @client.on 'connect', (er) => @emit "connect", ->
    @client.on 'close',        => @emit 'close'

    @reader = buffy.createReader()
    @client.pipe @reader

    headerLen = 4
    length = headerLen

    @client.on 'data', (data) =>
      #console.log "received raw data: #{data}"
      #console.log "reader byte ahead: "+@reader.bytesAhead()
      #console.log "reader bytesBuffered: "+@reader.bytesBuffered()

      while @reader.bytesAhead() >= length
        if length is headerLen and @reader.bytesAhead() >= headerLen
          length = @reader.int32BE() 
        if @reader.bytesAhead() >= length
          #console.log "eating data"
          rawMsg = @reader.ascii length
          #console.log "rawMsg: #{rawMsg}"
          message = []
          try
            message = sexp "(#{rawMsg})"
          catch er
            console.log "couldn't parse: " + pretty er
            console.log "original: " + pretty "(#{rawMsg})" 
          length = headerLen
        for evt in message
          #console.log "@emit \""+"#{evt[0]}".toLowerCase()+"\": #{pretty evt[1..]}"
          @emit evt[0].toLowerCase(), evt[1..]
        #else
        #  console.log "need to bufferize"


  send: (messages=[]) ->
    #console.log "sending messages"
    for msg in messages
      #console.log "command: #{pretty command}"
      msgString = sexp msg
      msgPacket = new Buffer 4 + msgString.length
      msgPacket.writeInt32BE msgString.length, 0
      msgPacket.write        msgString,        4, 'ascii'
      #console.log "msgPacket: \"#{msgPacket}\""
      #console.log "msgPacket len: #{msgPacket.length}"
      @client.write msgPacket

  close: ->
    try
      @client?.destroy?()
    catch er
      console.log "notice: couldn't destroy the socket"

class exports.Agent extends exports.Client
  constructor: (options={}) -> super port: 3100

class exports.Monitor extends exports.Client
  constructor: (options={}) -> super port: 3200

exports.startServer = startServer = (onReady) ->
  server = spawn "rcssserver3d", []

  isReady = no
  server.stdout.on 'data', (data)  -> 
    #log "rcssserver3d: #{data}"
    unless isReady
      isReady = yes
      onReady server

  server.stderr.on 'data', (data)  ->  #log "rcssserver3d: error: #{data}"
  server.on 'close', (code, signal) -> log "rcssserver3D: exited"
  server.stdin.end()


exports.startViewer = startViewer = (onReady) ->
  viewer = spawn "rcssmonitor3d", []

  isReady = no
  viewer.stdout.on 'data', (data)  -> 
    #log "rcssmonitor3d: #{data}"
    unless isReady
      isReady = yes
      onReady viewer

  viewer.stderr.on 'data', (data)  ->  #log "rcssmonitor3d: error: #{data}"
  viewer.on 'close', (code, signal) -> log "rcssmonitor3D: exited"
  viewer.stdin.end()

exports.checkServer = checkServer = (cb) ->
  console.log "Checking if Simspark Server is running.."
  psaux = execSync.exec('ps aux | grep rcssserver3d | grep -v grep | wc -l; exit 1');
  instances = ((Number) psaux.stdout) 
  if instances is 0
    console.log "Server is not running, starting it.."
    startServer (instance) ->
      console.log "Server is now started, connecting to it.."
      cb()
  else
    console.log "Server is already running, connecting to it.."
    cb()

exports.checkViewer = checkViewer = (cb) ->
  console.log "Checking if Simspark Viewer is running.."
  psaux = execSync.exec('ps aux | grep rcssmonitor3d | grep -v grep | wc -l; exit 1');
  instances = ((Number) psaux.stdout) 
  if instances is 0
    console.log "Viewer is not running, starting it.."
    startViewer (instance) ->
      console.log "Viewer is now started, connecting to it.."
      cb()
  else
    console.log "Viewer is already running, connecting to it.."
    cb()
