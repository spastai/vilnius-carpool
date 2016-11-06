{MapAdapter} = require "./MapAdapter.coffee"

publicConfig =
  key: Meteor.settings.public.googleApi.key
  # stagger_time:       1000, // for elevationPath
  # encode_polylines:   false,
  # secure:             true, // use https
  # proxy:              'http://127.0.0.1:9999' // optional, set a proxy for HTTP requests

api = new MapAdapter(publicConfig);

notificationService = new NotificationService({app_id: '545cd90b-40b2-49ef-964a-888e15415286', rest_api_key: "ZWI2N2JjNzQtMDM5Zi00MDExLWE1MzktZjJjMDZiMzIxY2M4"});

# d "NotificationService:", _(notificationService).functions();

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
  "api.v1.requestRide": (payload, to)->
    currentUser = Meteor.userId()
    users = Meteor.users.find({_id: {$ne: currentUser}});
    users.forEach (user)->
      d "Send requestRide to user", user?.onesignal?.playerId
      notificationService.sendNotification(user, "Ride request", "requestRide", payload);
    return true

  "api.v1.acceptRideRequest": (payload, riderId)->
    currentUser = Meteor.userId()
    user = Meteor.users.findOne({_id: riderId});
    d "Send acceptRideRequest to user", user?.onesignal?.playerId
    notificationService.sendNotification(user, "Ride request", "acceptRideRequest", payload);
    return true

  "api.v1.ackNotification": (notificationId)->
    notificationService.ackNotification(notificationId);

  "api.v1.getTripPath": (trip)->
    stops = Stops.find({}).fetch()
    api.getTripPath(trip, stops)
