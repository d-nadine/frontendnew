define('testdir/models/message.spec', function(require) {
  var RadiumAdapter = require('adapter'),
      Radium = require('radium');
  
  describe("Radium#Messages", function() {

    it("inherits from Radium.Core", function() {
      expect(Radium.Core.detect(Radium.Message)).toBeTruthy();
    });


    describe("when talking with the API", function() {
      var adapter, store, server, spy;

      beforeEach(function() {
        adapter = RadiumAdapter.create();
        store = DS.Store.create({adapter: adapter});
        server = sinon.fakeServer.create();
        spy = sinon.spy(jQuery, 'ajax');
      });
      
      afterEach(function() {
        adapter.destroy();
        store.destroy();
        server.restore();
        jQuery.ajax.restore();
      });
    });
  });

});