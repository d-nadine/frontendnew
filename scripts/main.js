require.config({
  baseUrl: 'scripts/',
  paths: {
    jquery: 'libs/jquery/jquery',
    jqueryUI: 'libs/jquery/jquery-ui.min',
    ember: 'libs/ember/ember',
    data: 'libs/ember/ember-data',
    text: 'libs/require/require.text',
  }
});

require(['core/app'], function() {
  Radium.MainStateManager.goToState('start');
});