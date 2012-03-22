/**
  Settings for Davis. Called in `app/javascripts/main.js` when DOM is ready.
  @require Davis.js
*/

Radium.Routes = function() {      
  this.configure(function() {
    this.generateRequestOnPageLoad = true;
  });

  this.get('/', function(req){
    Radium.App.send('loadPage', {page:'dashboard'});
  });
  
  this.get('/login', function(req) {
    Radium.App.goToState('loggedOut');
  });
  
  this.get('/:page/:id', function(req) {
    var page = req.params['page'],
        id = req.params['id'];
    Radium.App.send('loadPage', {
      page: page,
      action: 'show',
      param: id // <- Better key name than `param`?
    });
  });

  this.get('/:page', function(req) {
    var page = req.params['page'] || null;
    Radium.App.send('loadPage', {
      page: page,
      action: 'index'
    });
  });

};