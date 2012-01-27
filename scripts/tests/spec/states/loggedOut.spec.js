define('testdir/states/loggedOut.spec', function(require) {
  var Radium = require('radium');
  
  describe("Radium Logged Out State", function() {
        
    beforeEach(function() {
      var self = this;
      Ember.run(function() {Radium.App.goToState('loggedIn');});
      setFixtures('<div id="main"></div>');
    });
    
    afterEach(function() {
      Radium.App.destroy();
    });
    
    it("appends the login box on log out", function() {
      Ember.run(function() {Radium.App.goToState('loggedOut');});
      expect(Ember.$('#login-pane').length).toEqual(1);
    });
    
    it("removes the login box on log in", function() {
      Ember.run(function() {Radium.App.goToState('loggedIn');});
      expect(Ember.$('#login-pane').length).toEqual(0);
    });
    
    it("throws error when form fields are empty", function() {
      Ember.run(function() {Radium.App.goToState('loggedOut');});
      Ember.$('#login-pane').find('button').trigger('click');
      expect(Ember.$('#login-pane').find('input:first')).toHaveClass('error');
      expect(Ember.$('#login-pane').find('input:last')).toHaveClass('error');
    });
    
    it("sets main state chart property `isLoggedIn` to false", function() {
      Ember.run(function() {Radium.App.goToState('loggedOut');});
      expect(Radium.App.get('isLoggedIn')).toBeFalsy();
    });
  });
});