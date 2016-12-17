Package.describe({
  name: 'cucumber-fixtures',
  summary: ' /* Fill me in! */ ',
  version: '1.0.0',
  git: ' /* Fill me in! */ ',
  //testOnly: true
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('ecmascript');

  api.use(["mongo", "minimongo"]);
  api.use('xolvio:cleaner');
  
  api.use(['underscore', 'coffeescript'], ['server', 'client']);
  api.use(['accounts-base', 'accounts-password']);

  api.addFiles('hookFixtures.coffee', 'server');
  api.addAssets([
    'public/ron.jpg',
    'public/dick.jpg',
  ], 'client');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('cucumber-fixtures');
});
