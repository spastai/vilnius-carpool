assert = require('assert')
CarpoolClient = require('../../lib/carpool-client-ddpjs')
sockjs = require('sockjs-client');
_ = require('underscore')

d = console.log.bind console

# API_URL = "http://stg.arciau.lt/sockjs";
API_URL = "http://localhost:3000/sockjs";

loginUser = (client, username, password)->
  client.call("logout").then ()->
    client.call("login", { user : { email : username }, password : password })

describe 'Carpool client notifications', ->
  riderId = null
  username = null;
  notificationId = null

  before ()->
    # Client here is DDP client implementation
    @client = new CarpoolClient(sockjs);
    #@client.connect();
    @client.connect(API_URL).then ()=>
      loginUser(@client, "dick@tiktai.lt", "aaa")
    .then (userId)=>
      riderId = userId

  after ()->
    d "Remove temp users"

  describe 'requestRide', ->
    it 'should trigger notification', (done)->
      stamp = new Date().getTime()+"-"+Math.random()*180;
      @client.call "api.v1.requestRide", stamp: stamp
      d "Login into driver"
      loginUser(@client, "dick@tiktai.lt", "aaa").then ()=>
        d "to get request notification"
        subId = @client.subscribe "notifications", 1, (message)=>
          d "Wait for right notification", message
          if message.fields.payload?.stamp is stamp and message.msg is "added"
            notificationId = message.id;
            d "Unsubscribe", subId
            @client.unsubscribe subId
            done()
      .catch (err)->
        d "Got requestRide error"
        assert.ifError(err)

      return true # not to return Promise

  describe 'ackNotification', ->
    it 'should set recievedAt field', (done)->
      @client.subscribe "notifications", 1, (message)->
        if message.id is notificationId and message.msg is "changed"
          # d "Wait for change notification", message
          done()
      @client.call "api.v1.ackNotification", notificationId
      return true

  describe 'acceptRideRequest', ->
    stamp = new Date().getTime()+"-"+Math.random()*180;
    it 'should not throw error', ->
      @client.call("api.v1.acceptRideRequest", {stamp: stamp}, riderId)
