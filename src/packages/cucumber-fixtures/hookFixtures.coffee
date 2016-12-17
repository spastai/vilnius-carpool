{ resetDatabase } = require 'meteor/xolvio:cleaner'

# https://docs.meteor.com/api/methods.html#ddpratelimiter
Accounts.removeDefaultRateLimit();

Meteor.methods
  resetDatabase: ()->
    Meteor.wrapAsync(resetDatabase)(null)

  removeUsers: () ->
    console.log '---', "Cleanup users"
    Meteor.users.remove {}

  removeUser: (email) ->
    console.log '---', "Remove user"
    Meteor.users.remove {"emails.address": email}

  removeMessages: (email) ->
    user = Meteor.users.findOne {"emails.address": email};
    ChatHistory.remove({from: user._id});

  getUser: (email) ->
    user = Meteor.users.findOne {"emails.address": email};
    #console.log '---', "User found", user
    return user

  assureUser: (opts, extra) ->
    # console.log("Assure user", opts)
    try
      id =  Accounts.createUser
        email: opts.email
        password: if opts.password then opts.password else 'aaa'
      # console.log '---', "Created user #{id}", opts
      if extra
        err = Meteor.users.update _id: id, {$set: extra}
        # console.log '---', "Added extra to user #{id}", extra, err
    catch err
      # console.log '---', "Creation error", err unless err.error is 403

  assureStop: (title, loc) ->
    Stops.upsert({title: title}, {title: title, "loc" : loc or [  25.272159576416016,  54.69387649850695 ]})

  assureTrip: (trip) ->
    trip.owner = this.userId;
    trip.requests = [];
    Trips.upsert({fromAddress: trip.fromAddress, toAddress: trip.toAddress}, trip);

  removeTrips: (email) ->
    user = Meteor.users.findOne "emails.address": email
    #console.log '---', "Remove trips for", user
    if user
      Trips.remove owner: user._id

  removeNotifications: (email) ->
    user = Meteor.users.findOne "emails.address": email
    #console.log '---', "Remove notifications for", user
    NotificationHistory.remove userId: user._id
