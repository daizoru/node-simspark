{inspect} = require 'util'
net = require 'net'
Stream = require 'stream'

buffy = require 'buffy'

sexp = require './s-expression'

pretty = (obj) -> "#{inspect obj, no, 20, yes}"

isArray     = (obj) -> Array.isArray obj
isString    = (obj) -> !!(obj is '' or (obj and obj.charCodeAt and obj.substr))


class SimSpark extends Stream

  constructor: (host,port=3100) ->
    super @
    @client = net.connect port, host
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
          message = sexp "(#{rawMsg})"
          length = headerLen
          @emit 'data', message
        #else
        #  console.log "need to bufferize"

    @client.on 'connect', => @emit "connect", ->
    @client.on 'end', => @emit 'end'

  send: (messages=[]) ->
    console.log "sending messages"
    for msg in messages
      #console.log "command: #{pretty command}"
      msgString = sexp msg
      msgPacket = new Buffer 4 + msgString.length
      msgPacket.writeInt32BE msgString.length, 0
      msgPacket.write        msgString,        4, 'ascii'
      console.log "msgPacket: \"#{msgPacket}\""
      #console.log "msgPacket len: #{msgPacket.length}"
      @client.write msgPacket

module.exports = SimSpark
