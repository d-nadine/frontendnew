define('core/routes', function(require) {
  require('states/main');
    
  Radium.Routes = Davis(function() {      
    this.before(function(req) {
      console.log('logged in?', ISLOGGEDIN);
    });
    
    this.get('/', function(req){
      if (!ISLOGGEDIN) {
        req.redirect('/login');
      }
      Radium.appController.set('currentSection', 'dashboard');
      Radium.App.goToState('loggedIn.dashboard');
    });
    
    this.get('/login', function(req) {
      Radium.App.goToState('loggedOut');
    });
    
    this.get('/:page', function(req) {
      if (!ISLOGGEDIN) {
        req.redirect('/login');
        return false;
      }
      var page = req.params['page'];
      if (Radium.App.getState('loggedIn').getState(page)) {
        Radium.appController.set('currentSection', page);
        Radium.App.goToState('loggedIn.' + page);
      } else {
        Radium.App.goToState('error');
      }
    });
  }).start();
});