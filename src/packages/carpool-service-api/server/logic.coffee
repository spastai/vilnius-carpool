{d} = require "../lib/logger.coffee"
_ = require "underscore"

# d "Define getUserGroupsMembers"
getUserGroupsMembers = (userId)->
  d "Load all groups where #{userId} is a member"
  friends = []
  Groups.find({members: userId}).forEach (group)->
    # d "#{userId} is in group", group
    friends = _(friends).union(group.members)
  d "Friends", friends
  Meteor.users.find {_id: {$in: _(friends).without(userId)}}

canAddUserToGroup = (group)->
  d "Members:", group.members
  _(group.members).contains Meteor.userId() # or itself is in group

exports.addUserToGroup = (groupName, userId)->
  d "Adding user to group #{groupName}", userId
  group = Groups.findOne({name: groupName})
  unless group
    group = {name: groupName, members: [Meteor.userId()]}
    Groups.insert group
  # Should insert if only have rights
  throw new Error("No permission to add to group") unless canAddUserToGroup group
  Groups.update({name: groupName}, {$addToSet:{members: userId}})

exports.requestRide = (payload, to)->
  currentUser = Meteor.userId()
  users = getUserGroupsMembers currentUser
  users.forEach (user)->
    d "Send requestRide to user #{user._id}", user?.onesignal?.playerId
    notificationService.sendNotification(user, "Ride request", "requestRide", payload);
  return true
