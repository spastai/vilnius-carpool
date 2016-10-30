exports.assureUser = ()->
  userProfile =
    profile:
      name: "Dick",
      avatar: "/packages/cucumber-fixtures/public/dick.jpg"
  new Promise (resolve, reject)->
    Meteor.call 'assureUser', {email: 'dick@tiktai.lt'}, userProfile, (err, result)->
      if err then reject(err) else resolve(result)

exports.loginUser = ()->
  new Promise (resolve, reject)->
    user = user: {email: "dick@tiktai.lt"}, password: "aaa"
    Meteor.call "login", user, (err, result)->
      if err then reject(err) else resolve(result)
