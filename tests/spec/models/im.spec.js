define('testdir/models/im.spec', function(require) {
  var RadiumAdapter = require('adapter'),
      Radium = require('radium');
  
  describe("Radium#IM", function() {

    it("inherits from Radium.Message", function() {
      expect(Radium.Message.detect(Radium.Im)).toBeTruthy();
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

      it("sends an IM", function() {
        var sms;

        server.fakeHTTPMethods = true;
        server.respondWith(
          "POST", "/ims", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify({
            id: 19,
            created_at: "2011-12-15T10:38:39Z",
            updated_at: "2011-12-15T10:38:39Z",
            message: "How's it going?",
            sent_at: "2011-12-15T10:38:39Z",
            type: "Sms",
            sender: {
              id: 462,
              sender_type: "User"
            },
            users: [462],
            contacts: [131],
            comments: [],
            todos: []
          })
        ]);

        sms = store.createRecord(Radium.Im, {
                to: [131],
                message: "How's it going?"
              });

        store.load(Radium.User, {
          id: 462,
          name: "Kima Greggs"
        });

        store.load(Radium.Contact, {
          id: 131,
          name: "Bubbles"
        });

        sender = store.find(Radium.User, 462);
        recipients = store.findMany(Radium.Contact, [131]);

        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toEqual('/ims')
        expect(sms.get('imSender')).toEqual(sender.get('id'));
        expect(sms.get('contacts').getEach('id'))
            .toEqual(recipients.getEach('id'));
      });
    });
  });
});