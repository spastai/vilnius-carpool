Meteor.publish 'Notifications', (limit = 10)->
  d "#{this.userId} subscribed notifications"
  Notifications.find({fromUserId: this.userId}, {limit:limit, sort: {tss: -1}});
