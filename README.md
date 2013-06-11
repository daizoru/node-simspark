node-simspark
=============

Node interface to SimSpark, the simulator used for the RoboCup 3D Soccer Simulation League

## Installation

    $ npm install simspark

## Summary

```JavaScript
var simspark = require('simspark')

// shortcut for simspark.Client({hostname:"localhost", port:3100})
var agent = new simspark.Agent()

// event fired once we are connected to the server and can send/receive msg
agent.on('connect', function() {

  // send a message to the simulator. The message must be in SimSpark's s-expression format:
  // http://simspark.sourceforge.net/wiki/index.php/Network_Protocol
  agent.send([

    // here we init the scene using the nao agent model
    ["scene", "rsg/agent/nao/nao.rsg"],

    // spawn our robot, assigning it to a team and a number
    ["init", ["unum", 1], ["teamname", "BIG"]]
  ])

})

// event fired when the game state is updated
// events keys are lowercased to make it consistent and easier to remember
agent.on('gs', function (args) {


})

// server time
agent.on('time', function (args) {

})

// agent state
agent.on('agentstate', function (args) {

  var temperature = args[0][1]
  var battery     = args[1][1]

})

// Force-resistance sensor
agent.on('frp', function (args) {

})

// Gyroscope sensor
agent.on('gyr', function (args) {

})

// Accelerometer sensor
agent.on('acc', function (args) {

})       

// What the robot "see" (not an image, but semantic information)
agent.on('see', function (args) {

})

// Hinge Joint
agent.on('hj', function (args) {

})

// normal close
agent.on('close', function () {
	// handle close
})

// network error
agent.on('error', function (err) {

})
```
## Helpers

```JavaScript
var simspark = require('simspark')

// check that a server is running
// if not, one will be started
simspark.checkServer(function(){

  // check that a monitor (OpenGL viewer) is running
  // if not, one will be started
  simspark.checkMonitor(function(){

  })

})

```
## TODO

 * Support all the kind of messages
 * Add an example of using the Monitor API, see: http://simspark.sourceforge.net/wiki/index.php/Network_Protocol#Server.2FMonitor_Communication

## Changelog

#### 0.0.6

 * Coffee-Script 1.6.x
 * Now there are launchers for rcssserver3d and rcssmonitor

#### 0.0.5

 * Fixed the examples
 
#### 0.0.4

 * Events are now emitted directly
 * Rewrote example to JS to make it "more readable"

#### 0.0.3

 * ???

#### 0.0.2

 * removed console.logs

#### 0.0.1

 * removed auto-initalization of code

#### 0.0.0

 * initial version
 * basic streaming API
