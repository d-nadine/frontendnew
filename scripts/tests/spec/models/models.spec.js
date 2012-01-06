define('testdir/models/models.spec', function(require) {
  describe("Radium#Models", function() {
    require('./person.spec');
    require('./user.spec');
  });
});