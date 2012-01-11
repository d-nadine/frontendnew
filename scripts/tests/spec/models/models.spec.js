define('testdir/models/models.spec', function(require) {
  require('ember');
  require('data');
  var Radium = require('radium');
  
  describe("Radium#Models", function() {
    require('./person.spec');
    require('./user.spec');
    require('./contact.spec');
  });
});