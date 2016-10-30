GoogleMapsAPI = require "googlemaps"
turf = require "@turf/turf"
linestring = require "turf-linestring"
_ = require "underscore"

d = console.log.bind console

exports.MapAdapter = class @MapAdapter
  constructor: (publicConfig)->
    @mapsApi = new GoogleMapsAPI(publicConfig)

  # Might be not the most efficient algorythm
  isLocationOnEdge: (location, path, distance = 1000)->
    pt =
      'type': 'Feature'
      'properties': 'marker-color': '#0f0'
      'geometry':
        'type': 'Point'
        'coordinates': location
    ls = linestring path,
        "stroke": "#25561F",
        "stroke-width": 5
    buffer = turf.buffer(ls, distance, "meters")
    turf.inside(pt, buffer);

  routeTrip: (trip, waypoints)->
    d waypoints
    Meteor.wrapAsync(@mapsApi.directions, @mapsApi)(
      origin: trip.fromLoc.reverse().join ','
      destination: trip.toLoc.reverse().join ','
      mode: if 'rider' == trip.role then 'TRANSIT' else 'DRIVING'
      arrival_time: trip.bTime
      waypoints: waypoints
    )

  getTripPath: (trip, stops)->
    d "Stops on path", stops
    directRoutes = @routeTrip(trip);
    path = directRoutes.routes[0].overview_polyline.points
    stopsOnRoute = [{
      _id: "stop-a"
      loc: trip.fromLoc
      title: trip.fromAddress
    }]
    if "driver" == trip.role
      for stop in stops
        stopsOnRoute.push stop if @isLocationOnEdge stop.loc, path
    # Once nearby stops are know route the trip through them
    # stopsRoutes = @routeTrip trip, _(stopsOnRoute).pluck "loc"
    result =
      path: path
      stops: stopsOnRoute
      duration: directRoutes.routes[0].legs[0].duration.value
