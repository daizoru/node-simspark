{inspect} = require 'util'

sexp = require './s-expression'

pretty = (obj) -> "#{inspect obj, no, 20, yes}"

isArray     = (obj) -> Array.isArray obj
isString    = (obj) -> !!(obj is '' or (obj and obj.charCodeAt and obj.substr))

exports.SimSpark = SimSpark = (options={}) -> (onConnected=->) ->
  host = options.host ? '127.0.0.1'
  port = options.port ? 3100
  receive = options.receive ? ->

  dataHandler = (data) ->

    console.log "data sent by server: #{data}"
    len = msgPacket.readInt32LE msgString.length, 0
    msgString = msgPacket.toString 'ascii', 4, len
    msg = sexp msgString
    #s.destroy()

  closeHandler = ->
    console.log 'Connection closed'

  errorHandler = (err) ->
    console.log "#{err}"

  s = new net.Socket()
  console.log "trying to connect to #{host}:#{port}"
  s.connect port, host, ->
    console.log "CONNECTED TO: #{host}:#{port}"
    client.write 'I am Chuck Norris!'
    onConnected
      send: (messages=[]) ->
        console.log "sending messages:"
        for msg in messages
          #console.log "command: #{pretty command}"
          msgString = sexp msg
          msgPacket = new Buffer 4 + msgString.length
          msgPacket.writeInt32LE msgString.length, 0
          msgPacket.write        msgString,        4, 'ascii'
          console.log "msgPacket: \"#{msgPacket}\""
          console.log "msgPacket len: #{msgPacket.length}"
          s.write msgPacket
  s.on 'error', errorHandler
  s.on 'data', dataHandler
  s.on 'close', closeHandler
  return
