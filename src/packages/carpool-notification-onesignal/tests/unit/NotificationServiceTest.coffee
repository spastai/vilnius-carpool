assert = require('assert')
{NotificationService} = require "../../server/NotificationService.coffee"

d = console.log.bind console


service = new NotificationService({app_id: '545cd90b-40b2-49ef-964a-888e15415286', rest_api_key: "ZWI2N2JjNzQtMDM5Zi00MDExLWE1MzktZjJjMDZiMzIxY2M4"});
global.Meteor =
  userId: ()->
    "sinon-test-user"
global.Notifications =
  insert: ()->

describe "Notification service", ->
  describe 'send notification', ->
    it 'should get confirmation', ->
      user =
        onesignal:
          playerId: "905a1e28-384f-4f01-bf92-3281c4bc6834"
      service.sendNotification(user, "O sitos neturi gauti?")
