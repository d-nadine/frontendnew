define('testdir/models/group.spec', function(require) {
  var RadiumAdapter = require('adapter'),
      Radium = require('radium');
  
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

  describe("Radium#Group", function() {

    it("inherits from Radium.Core", function() {
      expect(Radium.Core.detect(Radium.Group)).toBeTruthy();
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

      it("creates a new Group", function() {
        var group;

        server.fakeHTTPMethods = true;
        server.respondWith(
          "POST", "/groups", [
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
        expect(spy.getCall(0).args[0].url).toBe('/groups');
        expect(store.find(Radium.Group, 21)).toBeDefined();
        expect(group.get('id')).toEqual(21);
        expect(group.getPath('contacts.length')).toEqual(4);
      });

      it("removes a contact from the group", function() {
        var group;

        store.loadMany(Radium.Contact, [
          {id: 1, name: 'Omar Little'},
          {id: 3, name: 'Butchie'},
          {id: 5, name: 'Brandon Wright'},
          {id: 6, name: 'John Bailey'}
        ]);
        store.load(Radium.Group, {
          id: 21,
          contacts: [1,3,5,6]
        });

        group = store.find(Radium.Group, 21);
        console.log(store.findAll(Radium.Contact).getEach('id'))
console.log(group.get('contacts').getEach('id'))
        // group.get('contacts').objectAt(3).removeObject();
        expect(group.getPath('contacts.length')).toEqual(3)
      });
    });
  });
});