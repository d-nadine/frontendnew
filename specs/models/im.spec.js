describe("Radium#IM", function() {

  it("inherits from Radium.Message", function() {
    expect(Radium.Message.detect(Radium.Im)).toBeTruthy();
  });


  describe("when talking with the API", function() {
    var adapter, store, server, spy;

    beforeEach(function() {
      adapter = DS.RadiumAdapter.create();
      store = DS.Store.create({revision: 3,adapter: adapter});
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
      var im;

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/api/ims", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify({
          id: 19,
          to: [131],
          created_at: "2011-12-15T10:38:39Z",
          updated_at: "2011-12-15T10:38:39Z",
          message: "How's it going?",
          sent_at: "2011-12-15T10:38:39Z",
          type: "Im",
          sender: 462,
          users: [462],
          comments: [],
          todos: []
        })
      ]);


      store.load(Radium.User, {
        id: 462,
        name: "Kima Greggs"
      });

      store.load(Radium.Contact, {
        id: 131,
        name: "Bubbles"
      });

      sender = store.find(Radium.User, 462);
      recipient = store.findMany(Radium.Contact, [131]);
      im = store.createRecord(Radium.Im, {
              message: "How's it going?"
            });
      
      im.get('to').pushObjects(recipient);

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toEqual('/api/ims')
      expect(im.get('to').getEach('id')).toEqual([131]);
    });
  });
});