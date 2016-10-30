{MapAdapter} = require "./logic.coffee"

publicConfig =
  key: Meteor.settings.public.googleApi.key
  # stagger_time:       1000, // for elevationPath
  # encode_polylines:   false,
  # secure:             true, // use https
  # proxy:              'http://127.0.0.1:9999' // optional, set a proxy for HTTP requests

api = new MapAdapter(publicConfig);

notificationService = new NotificationService({app_id: '545cd90b-40b2-49ef-964a-888e15415286', rest_api_key: "ZWI2N2JjNzQtMDM5Zi00MDExLWE1MzktZjJjMDZiMzIxY2M4"});

Meteor.methods
  "api.v1.saveLocation": (location)->
    d "Saving location", location
    id = Locations.insert
      tsi: new Date()
      userId: Meteor.userId();
      loc: location

  "api.v1.registerDevice": (playerId)->
    throw Error("You should login") unless Meteor.user();
    userId = Meteor.userId();
    Meteor.users.update({_id: userId}, {$set: {onesignal: {playerId: playerId}}})
    return userId

  # Rider is requesting ride
  "api.v1.requestRide": (userId, payload)->
    user = Meteor.users.findOne(userId);
    # d "Send notification to user #{userId}", user
    data = {
      action: "requestRide"
      fromUserId: Meteor.userId()
      payload: payload
    }
    notificationService.sendNotification([user.onesignal?.playerId], "Ride request", data);

  "api.v1.getTripPath": (trip)->
    stops = Stops.find({}).fetch()
    api.getTripPath(trip, stops)
