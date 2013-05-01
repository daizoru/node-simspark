node-simspark
=============

Node interface to SimSpark, the simulator used for the RoboCup 3D Soccer Simulation League

## Installation

    $ npm install simspark

## Summary

```JavaScript
var SimSpark = require('simspark')

var sim = new SimSpark()
// by default, this is equivalent to:  new SimSpark("localhost", 3100)

// event fired once we are connected to the server and can send/receive msg
sim.on('connect', function() {

  // send a message to the simulator. The message must be in SimSpark's s-expression format:
  // http://simspark.sourceforge.net/wiki/index.php/Network_Protocol
  sim.send([

    // here we init the scene using the nao agent model
    ["scene", "rsg/agent/nao/nao.rsg"],

    // spawn our robot, assigning it to a team and a number
    ["init", ["unum", 1], ["teamname", "BIG"]]
  ])

})

// event fired when the game state is updated
// events keys are lowercased to make it consistent and easier to remember
sim.on('gs', function (args) {


})

// server time
sim.on('time', function (args) {

})

// agent state
sim.on('agentstate', function (args) {

  var temperature = args[0][1]
  var battery     = args[1][1]

})

// Force-resistance sensor
sim.on('frp', function (args) {

})

// Gyroscope sensor
sim.on('gyr', function (args) {

})

// Accelerometer sensor
sim.on('acc', function (args) {

})       

// What the robot "see" (not an image, but semantic information)
sim.on('see', function (args) {

})

// Hinge Joint
sim.on('hj', function (args) {

})

// normal close
sim.on('close', function () {
	// handle close
})

// network error
sim.on('error', function (err) {

})
```

## TODO

 * Support all the kind of messages
 * Add an example of using the Monitor API, see: http://simspark.sourceforge.net/wiki/index.php/Network_Protocol#Server.2FMonitor_Communication

## Changelog

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
