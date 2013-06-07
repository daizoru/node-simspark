{inspect} = require 'util'
pretty = (x) -> inspect x, yes, 20, no
simspark = require 'simspark'

mon = new simspark.Monitor()

mon.on 'connect', ->
  console.log "connected! monitoring.."
 
mon.on 'data', (msg) ->
  console.log pretty msg

mon.on 'close', ->
  console.log "disconnected from server"