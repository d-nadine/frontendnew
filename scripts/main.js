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
  // TODO: Remove when deploying
  urlArgs: "bust=" +  (new Date()).getTime(),
  priority: [
    'jquery',
    'jqueryUI',
    'ember',
    'router',
    'data',
    'radium',
    'core/app'
  ]
});

require(['core/app'], function() {
  console.log('Application started...');
});