
Meteor.publish 'adminUserContacts', ->
  return this.ready() unless security.isAdmin(Meteor.users.findOne(@userId))
  da [ 'data-publish' ], 'Publish all user contacts'
  Meteor.users.find {},
    fields:
      'roles': true
      'profile': true
      "emails": true