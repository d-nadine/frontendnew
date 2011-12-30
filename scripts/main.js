require.config({
  baseUrl: 'scripts/',
  paths: {
    jquery: 'libs/jquery/jquery',
    jqueryUI: 'libs/jquery/jquery-ui.min',
    ember: 'libs/ember/ember',
    data: 'libs/ember/ember-data',
    router: 'libs/ember/ember-routing',
    radium: 'core/radium',
    text: 'libs/require/require.text',
  }
});

require(['core/app'], function() {
  if (ISLOGGEDIN) {
    Radium.App.goToState('loggedIn');
  }
  
});