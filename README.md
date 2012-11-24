node-simspark
=============

simple SimSpark stream client

## Installation

    $ npm install simspark

## Usage

basic send/receive usage:

```CoffeeScript
SimSpark = require 'simspark'

sim = new SimSpark "localhost"

sim.on 'connect', ->

  sim.send [
    ["scene", "rsg/agent/nao/nao.rsg"]
    ["init", ["unum", 1], ["teamname", "BIG"]]
  ]

sim.on 'data', (msg) ->

  t_delta = msg[0][1][1]
  console.log "server time: " + t_delta

sim.on 'end', -> console.log "disconnected"
```

## Changelog

#### 0.0.2

 * removed console.logs

#### 0.0.1

 * removed auto-initalization of code

#### 0.0.0

 * initial version
 * basic streaming API
