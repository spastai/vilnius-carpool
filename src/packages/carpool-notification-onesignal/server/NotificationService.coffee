https = require('https')

d = console.log.bind console

exports.NotificationService = class @NotificationService
  constructor: ({app_id, rest_api_key})->
    @app_id = app_id;
    @rest_api_key = rest_api_key;

  sendNotification: (recipients, text, action, payload)->
    headers =
      'Content-Type': 'application/json; charset=utf-8'
      'Authorization': "Basic #{@rest_api_key}"
    options =
      host: 'onesignal.com'
      port: 443
      path: '/api/v1/notifications'
      method: 'POST'
      headers: headers

    currentUser = Meteor.userId()
    data =
      action: action
      tss: new Date()
      fromUserId: currentUser
      payload: payload

    message =
      app_id: @app_id
      contents: 'en': text
      include_player_ids: recipients
      data: data

    Notifications.insert(data);
    # d "Sending notification", message
    new Promise (resolve, reject)->
      req = https.request(options, (res) ->
        res.on 'data', (data) ->
          resolve JSON.parse(data)
      )
      req.on 'error', (e) ->
        reject e
      req.write JSON.stringify(message)
      req.end()

  ackNotification: (notificationId)->
    d "Acknoledge notification", notificationId
    Notifications.update { _id: notificationId }, $set: 'recievedAt': new Date
