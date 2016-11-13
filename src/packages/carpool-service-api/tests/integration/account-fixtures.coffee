exports.callPromise = callPromise = (name, args...)->
  new Promise (resolve, reject)->
    Meteor.apply name, args, (err, response)->
      if err then reject(err) else resolve(response)

assureUser = (email, profile)->
  callPromise 'assureUser', {email: email}, profile

exports.assureUsers = ()->
  assureUser 'dick@tiktai.lt', {profile: { name: "Dick", avatar: "/packages/cucumber-fixtures/public/dick.jpg"}}
  .then ()->
    assureUser 'ron@tiktai.lt', {profile: { name: "Ron", avatar: "/packages/cucumber-fixtures/public/ron.jpg"}}

exports.loginUser = (username, password)->
  user = user: {email: username}, password: password
  callPromise "login", user
