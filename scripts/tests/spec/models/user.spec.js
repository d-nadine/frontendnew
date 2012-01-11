define('testdir/models/user.spec', function(require) {  
  
  require('ember');
  require('data')
  var Radium = require('radium');
  require('models/contact');
  require('models/user');
  
  var get = Ember.get, set = Ember.set, getPath = Ember.getPath;
  
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
    
    describe("", function() {
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
      });
      
      it("pings the server", function() {
        var spy = sinon.spy(jQuery, 'ajax');

        server.respondWith("GET", "/users/1",
              [200, {"Content-Type": "application/json"},
              '{"id":442,"created_at":"2011-12-13T15:15:35Z","updated_at":"2011-12-13T15:15:35Z","name":"Adam Hawkins","email":"user-1@example.com","api_key":"e68ff9eeeedbf05f2909f78eb960b69c2ae3fc2a","phone":"+1234987","account":294,contacts":[1,3,4,5,6,7],"deals":[1,3,4,5,6],"campaigns":[1,2,3],"following":[1,2,3],"followers":[1,2],"todos":[1,3,5,6],"meetings":[1,3,5,6],"reminders":[1,5,6,7],"notes":[183,81],"phone_calls":[57,85],"messages":[1,3,5],"activities":[237, 82347, 123847]}']);
        store.find(Radium.User, 1);
        server.respond();
        
        expect(spy).toHaveBeenCalled();
      });
    });
    
  });
  
});