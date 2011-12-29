define('tests/spec/app/radium', function(require) {  
  require('jquery');
  require('ember');
  require('radium');
  
  describe("Creates global Radium namespace", function() {
    it("expects Radium to exist", function() {
      expect(Radium).toBeDefined();
    });
  });
});