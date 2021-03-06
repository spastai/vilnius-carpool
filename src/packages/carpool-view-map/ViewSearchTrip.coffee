Template.CarpoolMap.rendered = ->
  toAddressElement = document.getElementById("trip-toAddress")
  mapView.addAutocomplete toAddressElement, (err, latlng, address, place)->
    # Google services for some reasone doesn't provide latlng
    mapView.setCurrentTripTo err, latlng, address, place, (refinedLatlng, refinedAddress)->
      updateUrl "bLoc", refinedLatlng
  fromAddressElement = document.getElementById("trip-fromAddress")
  mapView.addAutocomplete fromAddressElement, (err, latlng, address, place)->
    mapView.setCurrentTripFrom err, latlng, address, place, (refinedLatlng, refinedAddress)->
      updateUrl "aLoc", refinedLatlng

Template.CarpoolMap.events
  "click .save": (event, template) ->
    trip = template.data.currentTrip
    query =
      _id: trip._id
      role: $(event.currentTarget).val()
      group: template.data.group and template.data.group._id
      toLoc: googleServices.toLocation trip.to.latlng
      fromLoc: googleServices.toLocation trip.from.latlng
      toAddress: trip.to.address
      fromAddress: trip.from.address
      time: new Date()
    da ["trip-crud"], "Saving trip:", query
    $("#save-button").button "loading"
    carpoolService.saveTrip query, (error, routedTrip) ->
      #mapView.drawOwnTrip routedTrip # not needed as will be redrawn from collection
      $("*[id^='trip-toAddress']").val ""
      $("#save-button").button "reset"
  "click .requestRide": (event, template) ->
    da ["trip-request"], "Desktop Request ride #{@_id}", template.data.fromLoc
    carpoolService.requestRide @_id, template.data.fromLoc
  "click .acceptRequest": (event, template) ->
    da ["trip-request"], "Accept request", @
    carpoolService.acceptRequest @id, "accept"
  "click .removeTrip": (event, template) ->
    da ["trip-crud"], "Remove trip", @_id
    carpoolService.removeTrip @_id

Template.myTrip.helpers
  userText: ->
    user = Meteor.users.findOne(@userId)
    #d "Formating ", user
    getUserName user
