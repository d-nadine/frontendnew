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
    var RESPONSE = {
        id: 8302,
        created_at:"2012-02-21T18:41:04Z",
        updated_at:"2012-02-21T18:41:04Z",
        message:"Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.",
        sent_at:"2012-02-18T18:41:04Z",
        user:8,
        users:[8],
        contacts:[52],
        todos:[],
        comments:[],
        notes:[]
    };
  it("inherits from Radium.Message", function() {
    expect(Radium.Message.detect(Radium.Sms)).toBeTruthy();
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

    it("sends an SMS", function() {
      var sms;

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/api/sms", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify(RESPONSE)
      ]);

      sms = store.createRecord(Radium.Sms, {
        to: ["+12348123894"],
        message: "How's it going?"
      });

      store.load(Radium.User, {
        id: 8,
        name: "Jimmy McNulty"
      });

      sender = store.find(Radium.User, 8);

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toEqual('/api/sms')
    });
  });
});