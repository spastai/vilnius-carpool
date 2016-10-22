GoogleMapsAPI = require "googlemaps"

publicConfig =
  key: Meteor.settings.public.googleApi.key
  # stagger_time:       1000, // for elevationPath
  # encode_polylines:   false,
  # secure:             true, // use https
  # proxy:              'http://127.0.0.1:9999' // optional, set a proxy for HTTP requests
mapsApi = new GoogleMapsAPI(publicConfig)

routeTrip = (trip, waypoints)->
  Meteor.wrapAsync(mapsApi.directions, mapsApi)(
    origin: trip.fromLoc.reverse().join ','
    destination: trip.toLoc.reverse().join ','
    mode: if 'rider' == trip.role then 'TRANSIT' else 'DRIVING'
    arrival_time: trip.bTime
    waypoints: waypoints
  )

Meteor.methods
  "api.saveLocation": (location)->
    d "Saving location", location
    id = Locations.insert
      tsi: new Date()
      userId: Meteor.userId();
      loc: location

  "api.getTripPath": (trip)->
    routes = routeTrip(trip);
    path = routes.routes[0].overview_polyline.points
    if "driver" == trip.role
      stops = Stops.find({}).fetch()
