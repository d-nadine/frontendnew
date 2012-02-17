describe("Radium#SMS", function() {
    var CREATE_FIXTURE = {
          id: 19,
          created_at: "2011-12-15T10:38:39Z",
          updated_at: "2011-12-15T10:38:39Z",
          message: "Lorem ipsum dolo ...... ",
          sent_at: "2011-12-15T10:38:39Z",
          type: "Sms",
          sender: {
            id: 462,
            sender_type: "User"
          },
          users: [462],
          contacts: [153],
          comments: [],
          todos: []
        };

  it("inherits from Radium.Message", function() {
    expect(Radium.Message.detect(Radium.Sms)).toBeTruthy();
  });


  describe("when talking with the API", function() {
    var adapter, store, server, spy;

    beforeEach(function() {
      adapter = Radium.Adapter.create();
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

    it("sends an SMS", function() {
      var sms;

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/sms", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify({
          id: 19,
          created_at: "2011-12-15T10:38:39Z",
          updated_at: "2011-12-15T10:38:39Z",
          message: "Lorem ipsum dolo ...... ",
          sent_at: "2011-12-15T10:38:39Z",
          type: "Sms",
          sender: {
            id: 462,
            sender_type: "User"
          },
          users: [462],
          contacts: [153],
          comments: [],
          todos: []
        })
      ]);

      sms = store.createRecord(Radium.Sms, {
        to: ["+12348123894"],
        message: "How's it going?"
      });

      store.load(Radium.User, {
        id: 462,
        name: "Jimmy McNulty"
      });

      sender = store.find(Radium.User, 462);

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toEqual('/sms')
      expect(sms.get('smsSender')).toEqual(sender.get('id'));
    });
  });
});