require.config({
  baseUrl: 'scripts/',
  paths: {
    jquery: 'libs/jquery/jquery',
    jqueryUI: 'libs/jquery/jquery-ui.min',
    ember: 'libs/ember/ember',
    router: 'libs/ember/ember-routing',
    data: 'libs/ember/ember-data',
    radium: 'core/radium',
    text: 'libs/require/require.text',
  }
});

require(['core/app'], function() {
  if (ISLOGGEDIN) {
    Radium.App.goToState('loggedIn');
  }
  
  $(function() {
    SC.routes.add(':page', Radium.Router, 'pages');
    $('ul#main-nav').delegate('a', 'click', function() {
      console.log();
      var url = $(this).attr('href').substr(1);
      SC.routes.set('location', url);
      return false;
    });
  });
  
});