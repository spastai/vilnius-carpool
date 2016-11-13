{d} = require "../lib/logger.coffee"

d "Define getUserGroupsMembers"
getUserGroupsMembers = (userId)->
  d "Load all groups where #{userId} is a member"
  Meteor.users.find({_id: {$ne: userId}});

exports.requestRide = (payload, to)->
  currentUser = Meteor.userId()
  users = getUserGroupsMembers currentUser
  users.forEach (user)->
    d "Send requestRide to user", user?.onesignal?.playerId
    notificationService.sendNotification(user, "Ride request", "requestRide", payload);
  return true
