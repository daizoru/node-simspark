var SimSpark = require 'simspark'

var sim = new SimSpark().on('connect', function(){

  console.log("connected! sending messages..")

  sim.send([["scene", "rsg/agent/nao/nao.rsg"], ["init", ["unum", 1], ["teamname", "BIG"]]])

}).on('gs', function (args) { 

	console.log("server time: " + args[1][1]) 

}).on('close', function(){ 

	console.log("disconnected from server") 
})
