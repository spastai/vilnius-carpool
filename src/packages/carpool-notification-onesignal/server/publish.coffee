d = console.log.bind console

Meteor.publish 'notifications', (limit = 10)->
  d "#{this.userId} subscribed notifications"
  Notifications.find({toUserId: this.userId}, {limit:limit, sort: {tss: -1}});
