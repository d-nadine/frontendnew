Radium.Routes = Davis(function() {      
  this.get('/', function(req){
    Radium.App.send('loadPage', {page:'dashboard'});
  });
  
  this.get('/login', function(req) {
    Radium.App.goToState('loggedOut');
  });
  
  this.get('/:page', function(req) {
    var page = req.params['page'] || null;

    Radium.App.send('loadPage', {
      page: page
    });
  });

  this.get('/:page/:id', function(req) {
    var page = req.params['page'],
        id = req.params['id'];

    Radium.App.send('loadPage', {
      page: page,
      id: id
    });
  });
});