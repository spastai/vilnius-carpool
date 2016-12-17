Package.describe({
  name: 'carpool-service-api',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Npm.depends({
  moment : "2.13.0",
  googlemaps: "1.11.1",
  "@turf/turf": "3.5.2",
  "turf-linestring": "1.0.2"
});


Package.onUse(function(api) {
  api.versionsFrom('1.3');
  api.use('ecmascript');
  api.use(['underscore', 'coffeescript'], ['server', 'client']);

  // Meteor dependecies
  api.use(["mongo", "minimongo"]);

  // Custom libraries
  api.use('spastai:logw@0.0.4')

  api.use('spastai:carpool-service') // because of model
  // api.addFiles('lib/model.coffee');
  api.use('carpool-notification-onesignal')

  api.mainModule('server/serverApi.coffee', "server");
});

Package.onTest(function(api) {
  api.use('ecmascript');
  api.use(['underscore', 'coffeescript'], ['server', 'client']);

  api.use('tinytest');

  // Custom libraries
  api.use('spastai:logw@0.0.4')

  // For user creation
  api.use('cucumber-fixtures');

  api.use('carpool-service-api');

  api.addFiles('tests/integration/fixtures.coffee', ["server","client"]);

  api.addFiles('tests/integration/CarpoolServiceApiClientTest.coffee', "client");
  api.mainModule('tests/integration/CarpoolServiceApiServerTest.coffee', "server");
});
