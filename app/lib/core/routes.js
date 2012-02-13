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
    var page = req.params['page'] || null;
    
    if (!ISLOGGEDIN) {
      req.redirect('/login');
      return false;
    }


    if (Radium.App.getPath('loggedIn.' + page)) {
      Radium.appController.set('currentSection', page);
      Radium.App.goToState('loggedIn.' + page);
    } else {
      Radium.App.goToState('error');
    }
  });
});