assert = require('assert')
CarpoolClient = require('../../lib/carpool-client-ddpjs')
sockjs = require('sockjs-client');
_ = require('underscore')

d = console.log.bind console

API_URL = "http://localhost:3000/sockjs";

describe 'Carpool client notifications', ->
  userId = null
  username = null;
  notificationId = null

  before ()->
    # Client here is DDP client implementation
    @client = new CarpoolClient(sockjs);
    #@client.connect();
    @client.connect(API_URL).then ()=>
      @client.call("login", { user : { email : "ron@tiktai.lt" }, password : "aaa" })

  describe 'requestRide', ->
    it 'should trigger notification', (done)->
      stamp = new Date().getTime()+"-"+Math.random()*180;
      subId = @client.subscribe "Notifications", 1, (message)=>
        d "Wait for right notification", message
        if message.fields.payload?.stamp is stamp and message.msg is "added"
          notificationId = message.id;
          d "Unsubscribe", subId
          @client.unsubscribe subId
          done()
      @client.call "api.v1.requestRide", stamp: stamp
      return true # not to return Promise

  describe 'ackNotification', ->
    it 'should set recievedAt field', (done)->
      @client.subscribe "Notifications", 1, (message)->
        if message.id is notificationId and message.msg is "changed"
          # d "Wait for change notification", message
          done()
      @client.call "api.v1.ackNotification", notificationId
      return true
