define('testdir/app/radium', function(require) {  
  
  require('ember');
  var Radium = require('radium');
  
  describe("Radium", function() {
    it("exists", function() {
      expect(Radium).toBeDefined();
    });
    
    it("creates an instance of Ember#Application", function() {
      expect(Ember.typeOf(Radium)).toEqual('instance');
    });
  });
});