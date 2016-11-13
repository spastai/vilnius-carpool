CarpoolClient = require('../lib/carpool-client-ddpjs')
sockjs = require('sockjs-client');
_ = require('underscore');

d = console.log.bind console

client = new CarpoolClient(sockjs);
# client.connect();
client.connect("http://stg.arciau.lt/sockjs")

d "Connected"
client.call("login", { user : { email : "test" }, password : "test" }).then (response)->
  d "Logged in ", response
  client.subscribe "locations", response.result.id, 50, (message)->
    d message.fields.loc, new Date(message.fields.tsi['$date']);
  # location = [25.272159576416016, -90+Math.random()*180]
  # client.call "api.saveLocation", location
.catch (error)->
  d "Error", error
