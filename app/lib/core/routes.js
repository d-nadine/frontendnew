Radium.Routes = Davis(function() {      
  this.get('/', function(req){
    Radium.App.send('loadSection', 'dashboard');
  });
  
  this.get('/login', function(req) {
    Radium.App.goToState('loggedOut');
  });
  
  this.get('/:page', function(req) {
    var page = req.params['page'] || null;

    Radium.App.send('loadSection', page);
  });
});