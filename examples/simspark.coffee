SimSpark = require 'simspark'

sim = new SimSpark "localhost"

sim.on 'connect', ->
  console.log "connected! sending messages.."
  sim.send [
    ["scene", "rsg/agent/nao/nao.rsg"]
    ["init", ["unum", 1], ["teamname", "BIG"]]
  ]
sim.on 'data', (msg) ->
  t_delta = msg[0][1][1]
  console.log "server time: " + t_delta

sim.on 'end', ->
  console.log "disconnected from server"