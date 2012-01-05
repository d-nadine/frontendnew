define('testdir/app/radium', function(require) {  
  
  describe("Creates global Radium namespace", function() {
    it("expects Radium to exist", function() {
      expect(Radium).toBeDefined();
    });
  });
});