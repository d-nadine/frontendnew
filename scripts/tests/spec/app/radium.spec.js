define('testdir/app/radium', function(require) {  

  describe("Radium", function() {
    it("exists", function() {
      expect(Radium).toBeDefined();
    });
    
    it("creates an instance of Ember#Application", function() {
      expect(Ember.typeOf(Radium)).toEqual('instance');
    });
  });
});