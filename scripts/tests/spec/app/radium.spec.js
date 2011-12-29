define('tests/spec/app/radium', function(require) {  
  require('order!jquery');
  require('order!ember');
  require('order!radium');
  
  describe("Creates global Radium namespace", function() {
    it("expects Radium to exist", function() {
      expect(Radium).toBeDefined();
    });
  });
});