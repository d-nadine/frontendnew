define('core/routes', function(require) {
  require('jquery');
  require('ember');
  require('states/main');
  
  Radium.Routes = Davis(function() {      
    this.get('/', function(req){
      Radium.App.goToState('loggedIn.dashboard');
    });
    
    this.get('/:page', function(req) {
      var page = req.params['page'];
      if (Radium.App.getState('loggedIn').getState(page)) {
        Radium.App.goToState('loggedIn.' + page);
      } else {
        Radium.App.goToState('error');
      }
    });
  });
});