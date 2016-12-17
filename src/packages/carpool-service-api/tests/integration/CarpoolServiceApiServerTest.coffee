Stops.insert
  title: "Ciurlionio",
  loc: [25.2655, 54.6818]

Tinytest.addAsync "CarpooServiceApi - routing - getTripPath", (test, done) ->
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
