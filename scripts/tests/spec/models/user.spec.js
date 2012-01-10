define('testdir/models/user.spec', function(require) {  
  
  var get = Ember.get, set = Ember.set, getPath = Ember.getPath;
  
  describe("Radium#User", function() {
    afterEach(function() {
      set(DS, 'defaultStore', null);
    });
    
    it("inherits from Radium.Person", function() {
      expect(Radium.Person.detect(Radium.User)).toBeTruthy();
    });
    
    describe("creating a new user", function() {

      beforeEach(function() {
        this.store = DS.Store.create();
        this.store.createRecord(Radium.User, {
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
        this.store.createRecord(Radium.User, {
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
    
    
    describe("associations", function() {
      it("loads associated Radium#Contact", function() {
        var user, contact, store = DS.Store.create();
        
        store.createRecord(Radium.User, {
          id: 1,
          name: "Proposition Joe",
          contacts: [2]
        });
        
        store.load(Radium.Contact, {
          id: 2,
          name: "Marlo Stanfield",
          user: 1
        });
        
        user = store.find(Radium.User, 1);
        contact = store.find(Radium.Contact, 2);
        
        expect(Ember.isEqual(user.get('contacts').objectAt(0), contact)).toBeTruthy();
        expect(Ember.isEqual(contact.get('user'), user)).toBeTruthy();
        
      });
    });
    
    describe("WTF", function() {
      
    });
    it("should assign a contact from one user to another", function() {
      var user, contact, store = DS.Store.create();
      store.loadMany(Radium.User, [
        {
          id: 10,
          name: "Avon Barksdale",
          contacts: [101]
        },
        {
          id: 20,
          name: "Marlo Stanfield",
          contacts: [101]
        }
      ]);
      
      store.load(Radium.Contact, {
        id: 101,
        name: "Bubbles",
        user: 10
      });
      
      users = store.findAll(Radium.User);
      contact = store.find(Radium.Contact, 101);
      
      // contact.set('user', 20);
      console.log(store.findAll(Radium.User).getEach('name'));
      console.log(contact.get('user').get('name'));
      expect(contact.get('user').get('name')).toBe(users.objectAt(0).get('name'));
    });
  });
  
});