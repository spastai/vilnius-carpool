Package.describe({
  name: 'spastai:carpool-service',
  summary: 'Carpool specific package will be used to refactor code',
  version: '0.0.20',
  git: 'git@bitbucket.org:spastai/carpool-service.git'
});

Npm.depends({
  moment : "2.13.0",
  googlemaps: "1.11.1",
  "@turf/turf": "3.5.2",
  "turf-linestring": "1.0.2"
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('ecmascript');

  api.use(['underscore', 'coffeescript'], ['server', 'client']);
  api.use(["mongo", "minimongo"]);

  api.use(['accounts-base', 'accounts-password']);

  api.use("matb33:collection-hooks");
  api.use('momentjs:moment');

  api.use('spastai:logw@0.0.4')
  api.use("spastai:flow-controll@0.0.2");
  api.use(['spastai:google-client@0.0.14'], 'client');

  // api.use('carpool-notifications')
  api.use('carpool-notification-onesignal')

  api.addFiles('lib/model.coffee');
  api.addFiles('lib/helpers.coffee');

  api.addFiles('server/RecurrentTrips.coffee', "server");
  api.addFiles('server/TripMatcher.coffee', "server");
  // api.addFiles('server/logic.coffee', "server");
  api.addFiles('server/server.coffee', "server");
  api.addFiles('server/serverApi.coffee', "server");
  api.addFiles('server/publish.coffee', "server");

  api.addFiles('client/Progress.coffee');
  api.addFiles('client/CarpoolServiceClient.coffee', 'client');
  api.addFiles('client/ItenaryFactory.coffee');
});


Package.onTest(function(api) {
  api.use('ecmascript');
  api.use(['accounts-base', 'accounts-password']);

  api.use(['tinytest', 'test-helpers']);
  api.use(["tracker", "mongo", "minimongo"]);
  api.use(['underscore', 'coffeescript']);
  api.use('jquery');
  api.use('spastai:logw@0.0.4')
  api.use(['spastai:google-client@0.0.10'], 'client');

  api.use('spastai:carpool-service');

  api.use('cucumber-fixtures');
  api.addFiles('tests/integration/account-fixtures.coffee', ["server","client"]);

  api.addFiles('tests/integration/CarpoolServiceApiTest.coffee', ["server","client"]);
  api.addFiles('tests/integration/fixture-loadClient.coffee', "client");
  api.addAssets('tests/integration/RecurrentTripTests-recurrent-trip.json', "server");
  api.addAssets('tests/integration/RecurrentTripTests-trip.json', "server");
  api.addFiles('tests/integration/RecurrentTripTests.coffee');
  api.addAssets('tests/integration/CarpoolServiceClientTest-ride.json', "server");
  api.addAssets('tests/integration/CarpoolServiceClientTest-drive.json', "server");
  api.addFiles('tests/integration/CarpoolServiceClientTest.coffee');
  api.addFiles('tests/integration/ItenaryFactoryTest.coffee');
});
