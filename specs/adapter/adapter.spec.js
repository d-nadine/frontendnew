describe("RadiumAdapter", function() {
  var adapter, store, server, spy;

  beforeEach(function() {
    adapter = RadiumAdapter.create();
    store = DS.Store.create({revision: 3, adapter: adapter});
    server = sinon.fakeServer.create();
    spy = sinon.spy(jQuery, 'ajax');
  });
  
  afterEach(function() {
    adapter.destroy();
    store.destroy();
    server.restore();
    jQuery.ajax.restore();
  });

  describe("when making a queried request", function() {
  
    it("loads a user's activities", function() {
      store.load(Radium.Activity, {id: 53});
      
      var activity = store.find(Radium.Activity, {
        type: 'user',
        id: 13
      });

      spyOn(adapter, 'findQuery');
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/users/13/feed');
    });

    it("loads a contact's activities", function() {
      store.load(Radium.Activity, {id:67});

      var activity = store.find(Radium.Activity, {
        type: 'contact',
        id: 13
      });

      spyOn(adapter, 'findQuery');
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/contacts/13/feed');
    });

    it("loads a deal's activities", function() {
      store.load(Radium.Activity, {id:67});

      var activity = store.find(Radium.Activity, {
        type: 'deal',
        id: 13
      });

      spyOn(adapter, 'findQuery');
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/deals/13/feed');
    });

    it("loads a campaign's activities", function() {
      store.load(Radium.Activity, {id:67});

      var activity = store.find(Radium.Activity, {
        type: 'campaign',
        id: 13
      });

      spyOn(adapter, 'findQuery');
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/campaigns/13/feed');
    });

    it("loads a group's activities", function() {
      store.load(Radium.Activity, {id:67});

      var activity = store.find(Radium.Activity, {
        type: 'group',
        id: 13
      });

      spyOn(adapter, 'findQuery');
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/groups/13/feed');
    });
  });

  describe("when receiving nested data", function() {
    it("normalizes the owner ID", function() {
      var test = store.find(Radium.Activity, {
        type: 'user',
        id: 53
      });

      server.respondWith(
        "GET", "/api/users/53/feed", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify([{
          id: 53,
          owner: {
            id: 'R19143',
            user: {
              id: 77,
              contacts: [313, 1213],
              meetings: [12314, 12]
            }
          },
          reference: {
            id: 'R13431',
            todo: {
              id: 11
            }
          }
        }])
      ]);

      server.respond();
      expect(spy).toHaveBeenCalled();
      expect(test.getPath('firstObject.owner.user.id')).toEqual(77);
      expect(spy.getCall(0).args[0].url).toBe('/api/users/53/feed');
    });

    it("loads a single page", function() {

    });

    it("loads all models split across several pages", function() {
      var deals;


      server.respondWith(
        "GET", "/api/deals", [
        200, 
        {
          "Content-Type": "application/json", 
          "x-radium-current-page": "1",
          "x-radium-total-pages": "2"
        },
        JSON.stringify([
          {id: 1},
          {id: 2},
          {id: 3}
        ])
      ]);

      deals = store.findMany(Radium.Deal, [1,2,3]);
      server.respond();
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/deals');
      expect(deals.getEach('id')).toEqual([1,2,3]);
    });

    it("loads a query to find page=0", function() {
      var deals;
      server.respondWith(
        "GET", "/api/deals?page=0", [
        200, 
        {
          "Content-Type": "application/json", 
          "x-radium-current-page": "1",
          "x-radium-total-pages": "2",

        },
        JSON.stringify([
          {id: 1},
          {id: 2},
          {id: 3}
        ])
      ]);

      deals = store.find(Radium.Deal, {
        page: 0
      });
      server.respond();
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/deals');
      expect(spy.getCall(0).args[0].data.page).toEqual(0);
      expect(deals.getEach('id')).toEqual([1,2,3]);
    });
  });

});