work in progress client for SimSpark monolithic (sic) server

this project is designed for a node-substrate demo, 
so it's (mostly) just a wrapper:
 
 * connect to server
 * send serialized (in s-expression format) lists via socket
 * listen and deserialize s-expressions to lists

For the moment seralization works in both way,
however connection to server is still broken - hope I'll be able to fix it soon

TODO

* figure out how to manage buffers, streams and stuff