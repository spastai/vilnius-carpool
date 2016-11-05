CarpoolClient = require('../lib/carpool-client-ddpjs')
sockjs = require('sockjs-client');
_ = require('underscore');

d = console.log.bind console

client = new CarpoolClient(sockjs);
# client.connect();
client.connect("http://stg.arciau.lt/sockjs")

client.call("login", { user : { email : "test" }, password : "test" }).then (response)->
  d "Logged in"
  client.call "api.v1.registerDevice", "e7452db6-2d80-435f-b765-3bcca100baec"
.then ()->
  d "Device registered"
