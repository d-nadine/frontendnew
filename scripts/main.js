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
  }
});

require(['core/app'], function() {
  $('body').delegate('a', 'click', function(e) {e.preventDefault();});
  if (ISLOGGEDIN) {
    Radium.Routes.start();
    Radium.App.goToState('loggedIn');
  }
  
});