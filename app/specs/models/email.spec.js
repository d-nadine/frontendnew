describe("Radium#Email", function() {
    var CREATE_FIXTURE = {
      id: 21,
      created_at: "2011-12-15T12:39:01Z",
      updated_at: "2011-12-15T12:39:01Z",
      name: "Partners",
      email: "joe@partners.com",
      phone: "+13249812348",
      is_public: false,
      contacts: [1,3,5,6],
      deals: [],
      user: 55,
      avatar: null
    };

  it("inherits from Radium.Message", function() {
    expect(Radium.Message.detect(Radium.Email)).toBeTruthy();
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

    it("sends an email", function() {
      var email, sender;

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/emails", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify({
          id: 19,
          created_at: "2011-12-15T10:38:39Z",
          updated_at: "2011-12-15T10:38:39Z",
          subject: "Hey",
          message: "How's it going?",
          sent_at: "2011-12-15T10:38:39Z",
          html: null,
          type: "Email",
          sender: {
            "id": 462,
            "sender_type": "User"
          },
          users: [462],
          contacts: [153],
          comments: [],
          attachments: [],
          todos: [],
          to: ["example@example.com"],
          cc: ["someone@else.com"]
        })
      ]);

      email = store.createRecord(Radium.Email, {
        to: ["example@example.com"],
        cc: ["someone@else.com"], 
        subject: "Hey",
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
      // Right now we can get the sender ID, but should look at retrieving
      // nested objects.
      expect(email.get('emailSender')).toEqual(sender.get('id'));
    });
  });
});