https = require('https')

exports.NotificationService = class @NotificationService
  constructor: ({app_id, rest_api_key})->
    @app_id = app_id;
    @rest_api_key = rest_api_key; 

  sendNotification: (text, include = [ 'All' ])->
    headers =
      'Content-Type': 'application/json; charset=utf-8'
      'Authorization': "Basic #{@rest_api_key}"
    options =
      host: 'onesignal.com'
      port: 443
      path: '/api/v1/notifications'
      method: 'POST'
      headers: headers
    message =
      app_id: @app_id
      contents: 'en': text
      include_player_ids: ["e7452db6-2d80-435f-b765-3bcca100baec"]

    new Promise (resolve, reject)->
      req = https.request(options, (res) ->
        res.on 'data', (data) ->
          resolve JSON.parse(data)
      )
      req.on 'error', (e) ->
        reject e
      req.write JSON.stringify(message)
      req.end()
