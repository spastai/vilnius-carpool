{assureUsers, loginUser, callPromise} = require "./account-fixtures.coffee"

if Meteor.isClient
  beforeRequestRide = ()->
    assureUsers().then (result)->
      loginUser("dick@tiktai.lt", "aaa");
    .then ()->
      callPromise "api.v1.registerDevice", "e7452db6-2d80-435f-b765-3bcca100baec"

  Tinytest.addAsync "CarpooServiceApi - notifications - requestRide ", (test, done) ->
    beforeRequestRide().then (userId)->
      loginUser("ron@tiktai.lt", "aaa");
    .then (userId)->
      # d "Still have user", userId
      callPromise "api.v1.requestRide"
    .then ()->
      done();
    .catch (err)->
      d "Error occured before rideRequest", err
      done();

  Tinytest.addAsync "CarpooServiceApi - notifications - acceptRideRequest      ", (test, done) ->
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
      d "Error occured before acceptRideRequest", err
      done();


if Meteor.isServer
  Stops.insert
    title: "Ciurlionio",
    loc: [25.2655, 54.6818]

  Tinytest.addAsync "CarpooServiceApi - routing - getTripPath ", (test, done) ->
    trip =
      role: "driver",
      fromLoc: [25.27430490000006, 54.672818],
      toLoc: [25.27726899999993, 54.69814],
      bTime: new Date()
    Meteor.call "api.v1.getTripPath", trip, (err, route)->
      test.isUndefined(err, "Got error:"+err)
      test.isNotNull(route, "Route should be returned")
      d "Got route", route
      done();
