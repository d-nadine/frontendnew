describe("Radium#Campaign", function() {
  
  it("inherits from Radium.Core", function() {
    expect(Radium.Core.detect(Radium.Campaign)).toBeTruthy();
  });

  describe("when talking with the API", function() {
    var adapter, store, server, spy;

    beforeEach(function() {
      adapter = RadiumAdapter.create({bulkCommit: false});
      store = DS.Store.create({revision: 2,adapter: adapter});
      server = sinon.fakeServer.create();
      spy = sinon.spy(jQuery, 'ajax');
    });
    
    afterEach(function() {
      adapter.destroy();
      store.destroy();
      server.restore();
      jQuery.ajax.restore();
    });

    it("creates a campaign", function() {
      var campaign;
      
      server.fakeHTTPMethods = true;
      server.respondWith("POST", "/api/campaigns", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify({
          id: "101",
          name: "Campaign 3",
          description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.",
          ends_at: "2011-12-21T14:55:25Z",
          currency: "USD",
          target: "10000.0",
          user_id: 201,
          approve_following_requests: true,
          contact_ids: [1,2,3,5]
        })
      ]);

      campaign = store.createRecord(Radium.Campaign, {
        name: "Campaign 3",
        description: "Lorem ipsum dolor sit amet.",
        ends_at: "2011-12-21T14:55:25Z",
        currency: "USD",
        target: "10000.0",
        user_id: 201,
        approve_following_requests: true,
        contact_ids: [1,2,3,5]
      })

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/campaigns');
    });

    it("creates a campaign url", function() {
      var campaign

      store.load(Radium.Campaign, {
        id: 1
      });
      campaign = store.find(Radium.Campaign, 1);
      expect(campaign.get('url')).toEqual('/campaigns/1');
    });


    it("adds a contact to a campaign", function() {
      var campaign, contact;

      server.fakeHTTPMethods = true;
      server.respondWith("POST", "/campaigns", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify({
          id: 101,
          name: "Campaign 3",
          description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.",
          ends_at: "2011-12-21T14:55:25Z",
          currency: "USD",
          target: "10000.0",
          user: 201,
          approve_following_requests: true,
          contacts: [1,3,5,6]
        })
      ]);

      store.load(Radium.Campaign, {
        id: 101,
        name: "Campaign 3",
        description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.",
        ends_at: "2011-12-21T14:55:25Z",
        currency: "USD",
        target: "10000.0",
        user: 201,
        approve_following_requests: true,
        contacts: [1,3,5]
      });

      store.loadMany(Radium.Contact, [
        {id: 1, name: 'Omar Little'},
        {id: 3, name: 'Butchie'},
        {id: 5, name: 'Brandon Wright'},
        {id: 6, name: 'John Bailey'}
      ]);

      campaign = store.find(Radium.Campaign, 101);
      contact = store.find(Radium.Contact, 6);

      campaign.get('contacts').pushObject(contact);

      store.commit();
      server.respond();

      expect(campaign.getPath('contacts.length')).toEqual(4);
      expect(campaign.get('contacts').getEach('id')).toEqual([1,3,5,6]);
    });

  });
});