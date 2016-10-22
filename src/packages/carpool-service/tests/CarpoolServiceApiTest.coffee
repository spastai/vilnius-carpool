Tinytest.addAsync "CarpooServiceApi - saveTrip ", (test, done) ->
  trip =
    toLoc : [25.26246500000002, 54.6779097]
    fromLoc : [25.305228100000022,54.6877209]
    bTime: new Date()
  d "Calling get trip path"

  Meteor.call "api.getTripPath", trip, (err, route)->
    test.isUndefined(err, "Got error:"+err)
    test.isNotNull(route, "Route should be returned")
    d "Got route", route
    done();
