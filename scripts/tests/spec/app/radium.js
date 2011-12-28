define('tests/spec/app/radium', ['ember', 'radium'], function() {
  describe("Creates global Radium namespace", function() {
    it("expects Radium to exist", function() {
      expect(window.Radium).toBeDefined();
    });
  });
});