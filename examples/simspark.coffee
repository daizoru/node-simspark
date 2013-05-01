SimSpark = require 'simspark'

sim = new SimSpark()

sim.on 'connect', ->
  console.log "connected! sending messages.."
  sim.send [
    ["scene", "rsg/agent/nao/nao.rsg"]
    ["init", ["unum", 1], ["teamname", "BIG"]]
  ]
sim.on 'gs', (args) ->
  t_delta = args[1][1]
  console.log "server time: " + t_delta

sim.on 'close', ->
  console.log "disconnected from server"