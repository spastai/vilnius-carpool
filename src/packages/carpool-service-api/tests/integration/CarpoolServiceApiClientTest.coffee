{assureUsers, loginUser, callPromise, subscribePromise} = require "./fixtures.coffee"

beforeRequestRide = ()->
  assureUsers()
  .then (result)->
    loginUser("dick@tiktai.lt", "aaa");
  .then ()->
    callPromise "api.v1.registerDevice", "e7452db6-2d80-435f-b765-3bcca100baec"

Tinytest.addAsync "CarpooServiceApi - groups - create new group", (test, done) ->
  assureUsers().then ->
    riderId = null;
    loginUser("ron@tiktai.lt", "aaa").then (user)->
      riderId = user.id
      d "Logged in as ron #{riderId}"
      loginUser("dick@tiktai.lt", "aaa")
    .then (user)->
      d "Logged in as dick #{user.id}"
      #  Create group and add rider
      Meteor.call "api.v1.addUserToGroup", "first", riderId, (err)->
        d "Group first created", err
        done();
    .catch (err)->
      d "Got error", err
      test.isNull(err)
      done();

Tinytest.addAsync "CarpooServiceApi - notifications - requestRide", (test, done) ->
  riderId = null;
  beforeRequestRide().then (user)->
    loginUser("ron@tiktai.lt", "aaa");
  .then (user)->
    riderId = user.id
    callPromise("api.v1.requestRide")
  .then ()->
    loginUser("dick@tiktai.lt", "aaa")
  .then ()->
    subscribePromise("notifications")
  .then ()->
    # Last notification should be from ron
    notification = Notifications.findOne({}, {sort: tss: -1});
    test.equal riderId, notification?.fromUserId, "Dick should get notification"
  .then ->
    callPromise("logout")
  .then ()->
    loginUser("eve@tiktai.lt", "aaa");
  .then ()->
    subscribePromise("notifications")
  .then ()->
    notification = Notifications.findOne {}, {sort: {tss: -1}}
    d "Eve shouldn get notification", notification
    test.isUndefined notification, "Eve shouldn't get notification"
  .then ()->
    done();
  .catch (err)->
    d err
    test.isNull err, "Error occured before rideRequest"
    done();

Tinytest.addAsync "CarpooServiceApi - notifications - acceptRideRequest", (test, done) ->
  riderId = null;
  beforeRequestRide().then (userId)->
    loginUser("ron@tiktai.lt", "aaa");
  .then (userId)->
    riderId = userId
    loginUser("dick@tiktai.lt", "aaa");
  .then (userId)->
    callPromise "api.v1.acceptRideRequest", riderId
  .then ()->
    done();
  .catch (err)->
    test.isNull err, "Error occured before acceptRideRequest"
    done();
