require.config({
  baseUrl: 'scripts/',
  paths: {
    jquery: 'libs/jquery/jquery',
    jqueryUI: 'libs/jquery/jquery-ui.min',
    ember: 'libs/ember/ember',
    router: 'libs/davis',
    data: 'libs/ember/ember-data',
    radium: 'core/radium',
    text: 'libs/require/require.text',
  },
  priority: [
    'jquery',
    'jqueryUI',
    'ember',
    'router',
    'data',
    'radium',
    // 'core/app',
    // 'models/main',
    // 'controllers/main',
    // 'states/main',
    // 'core/routes'
  ]
});

require(['core/app'], function() {
  console.log('started...');
});