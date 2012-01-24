define('testdir/models/user.spec', function(require) {  
var Radium = require('radium');
  var get = Ember.get, set = Ember.set, getPath = Ember.getPath;
  
  // FIXTURES
  var GET_FIXTURE = {user: {
    id: 1,
    name: "Jimmy McNulty",
    phone: "+1 410 555-5555",
    contacts: [101, 102, 103]
  }};
  
  var PUT_FIXTURE = {user: {
    id: 1,
    name: "Jimmy McNulty",
    phone: "+1 410 555-5555",
    contacts: [101, 102, 103]
  }};
  
  
  describe("Radium#User", function() {
    
    it("inherits from Radium.Person", function() {
      expect(Radium.Person.detect(Radium.User)).toBeTruthy();
    });
    
    describe("creating a new user", function() {

      beforeEach(function() {
        this.store = DS.Store.create();
        this.store.load(Radium.User, {
          "id": 1,
          "email": "example@example.com",
          "name": "Adam Hawkins",
          "phone_number": "+1234987"
        });
      });

      afterEach(function() {
        this.store.destroy();
      });

      it("creates a user", function() {
        expect(this.store.findAll(Radium.User).get('length')).toBe(1);
      });

      it("loads and processes their name", function() {
        var person = this.store.find(Radium.User, 1);
        expect(person.get('name')).toBe("Adam Hawkins");
        expect(person.get('firstName')).toBe("Adam");
        expect(person.get('abbrName')).toBe("Adam H.");
      });
    });

    describe("updating a user", function() {
      beforeEach(function() {
        this.store = DS.Store.create();
        this.store.load(Radium.User, {
          "id": 1,
          "email": "example@example.com",
          "name": "Adam Hawkins",
          "phone_number": "+1234987"
        });
      });

      afterEach(function() {
        this.store.destroy();
      });

      it("updates name", function() {
        var user = this.store.find(Radium.User, 1);
        user.set('name', "Joshua Jones");
        expect(user.get('firstName')).toBe("Joshua");
      });
    });
    
    describe("when talking with the API", function() {
      var adapter, store, server;
      
      beforeEach(function() {
        adapter = DS.RESTAdapter.create();
        store = DS.Store.create({adapter: adapter});
        server = sinon.fakeServer.create();
        
      });
      
      afterEach(function() {
        adapter.destroy();
        store.destroy();
        server.restore();
        jQuery.ajax.restore();
      });

      it("creates a new user", function() {
        var spy, user, 
            fixture = {
              name: "Brother Mouzone",
              email: "harperslover@hotmail.com"
            };
        
        server.fakeHTTPMethods = true;
        spy = sinon.spy(jQuery, 'ajax');

        user = store.createRecord(Radium.User, fixture);

        server.respondWith("POST", "/users", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify({users: [jQuery.extend({id: 11231}, fixture)]})
        ]);

        store.commit();
        server.respond();

        expect(server.requests[0].method).toEqual("POST");
        expect(user.get('isNew')).toBeFalsy();
        expect(user.get('id')).toEqual(11231);
        expect(spy).toHaveBeenCalled();
      });
      
      it("loads a user", function() {
        var spy, user;
        
        spy = sinon.spy(jQuery, 'ajax');

        server.respondWith("GET", "/users/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(GET_FIXTURE)
        ]);
        store.loadMany(Radium.Contact, [
          {
            id: 101
          }, {
            id: 102
          }, {
            id: 103
          }]);
        user = store.find(Radium.User, 1);
        server.respond();
        expect(spy).toHaveBeenCalled();
        expect(user.get('name')).toBe("Jimmy McNulty");

        expect(user.getPath('contacts.length')).toEqual(3);
        expect(user.get('contacts').getEach('id')).toEqual([101, 102, 103]);
        expect(spy).toHaveBeenCalled();
      });
      
      it("updates a user", function() {
        var spy, user;
        
        server.fakeHTTPMethods = true;
        
        store.load(Radium.User, GET_FIXTURE.user);

        user = store.find(Radium.User, 1);
        spy = sinon.spy(jQuery, 'ajax');
        
        server.respondWith("PUT", "/users/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(PUT_FIXTURE)
        ]);

        user.set('phone', '+1 410 555-4444');

        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(user.get('phone')).toBe("+1 410 555-4444");
      });
    });
    
  });
  
});