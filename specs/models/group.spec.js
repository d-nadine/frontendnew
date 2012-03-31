describe("Radium#Group", function() {
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

  it("inherits from Radium.Core", function() {
    expect(Radium.Core.detect(Radium.Group)).toBeTruthy();
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

    it("creates a new Group", function() {
      var group;

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/api/groups", [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(CREATE_FIXTURE)
        ]
      );

      group = store.createRecord(Radium.Group, {
        name: "Partners",
        contact_ids: [1,3,5,6]
      });

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/groups');
      expect(store.find(Radium.Group, 21)).toBeDefined();
      expect(group.get('id')).toEqual(21);
      expect(group.getPath('contacts.length')).toEqual(4);
    });


    xit("adds a Contact to a Group", function() {
      var group, contact;

      store.loadMany(Radium.Contact, [
        {id: 1, name: 'Omar Little'},
        {id: 3, name: 'Butchie'},
        {id: 5, name: 'Brandon Wright'},
        {id: 6, name: 'John Bailey'}
      ]);
      store.load(Radium.Group, {
        id: 44,
        contacts: [1,3,5]
      });
      
      contact = store.find(Radium.Contact, 6);
      group = store.find(Radium.Group, 44);

      expect(group.getPath('contacts.length')).toEqual(3);  
      group.get('contacts').pushObject(contact);
      expect(group.getPath('contacts.length')).toEqual(4);
    });


    xit("removes a Contact from a Group", function() {
      var group;

      store.loadMany(Radium.Contact, [
        {id: 1, name: 'Omar Little'},
        {id: 3, name: 'Butchie'},
        {id: 5, name: 'Brandon Wright'},
        {id: 6, name: 'John Bailey'}
      ]);
      store.load(Radium.Group, {
        id: 44,
        deals: [11],
        contacts: [1,3]
      });
      
      group = store.find(Radium.Group, 44);
      group.get('contacts').removeAt(1);
      expect(group.getPath('contacts.length')).toEqual(3)
    });
  });
});