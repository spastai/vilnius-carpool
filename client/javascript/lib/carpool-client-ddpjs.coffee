DDP = require("ddp.js");
URL = require('url');

d = console.log.bind console

module.exports = class @CarpoolClient
  constructor: (@socket)->
    @subCallbacks = {}
  ###
  # Connect to the Meteor Server
  ###
  connect: (urlString = "http://localhost:3000/sockjs")->
    options =
      endpoint: urlString,
      SocketConstructor: @socket
    @ddp = new DDP.default(options);

    new Promise (resolve, reject) =>
      @ddp.on "connected", ()->
        resolve();

  call: (cmd, params...)->
    new Promise (resolve, reject) =>
      methodId = @ddp.method cmd, params
      @ddp.on "result", (message)->
        if message.id is methodId && !message.error
          resolve(message)
        else
          reject(message.error)

  subscribe: (subscribtion, params..., cb)->
    subId = @ddp.sub(subscribtion, params);
    # @ddp.on "ready", (message)->
    #   d "Subscribtion ready:",message
    @subCallbacks[subId] = cb
    @ddp.on "added", cb
    @ddp.on "changed", cb
    @ddp.on "removed", cb
    return subId

  unsubscribe: (subId)->
    @ddp.unsub(subId);
    @ddp.off "added", @subCallbacks[subId]
    @ddp.off "changed", @subCallbacks[subId]
    @ddp.off "removed", @subCallbacks[subId]
