define('testdir/models/user.spec', function(require) {
  
  require('ember');
  require('data');
  require('models/person');
  require('models/user');
  
  describe("Radium#User", function() {
    it("inherits from Radium.Person", function() {
      expect(Radium.Person.detect(Radium.User)).toBeTruthy();
    });
  });
  
});