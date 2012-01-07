define('testdir/models/user.spec', function(require) {
  
  require('ember');
  require('data');
  require('radium');
  require('models/contact');
  require('models/user');
  
  describe("Radium#User", function() {
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
        })
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
        this.store = DS.Store.create();
        this.store.createRecord(Radium.User, {
          "id": 1,
          "name": "Proposition Joe",
          "contacts": [2]
        });
        this.store.createRecord(Radium.Contact, {
          "id": 2,
          "name": "Marlo Stanfield"
        });
        
        expect(this.store.find(Radium.User, 1).get('contacts').objectAt(0).get('name'))
          .toBe("Marlo Stanfield");
      });
      
      it("should assign a contact from one user to another", function() {
        this.store = DS.Store.create();
        this.store.loadMany(Radium.User, 
          {
            "id": 1,
            "name": "Avon Barksdale",
            "contacts": [2]
          },
          {
            "id": 2,
            "name": "Marlo Stanfield",
            "contacts": []
          }
        );
        this.store.createRecord(Radium.Contact, {
          "id": 102,
          "name": "Bubbles",
          "user": 1
        });
        
        var contact = this.store.find(Radium.Contact, 102);
        
        // expect(this.store.find(Radium.User, 2).get('contacts')).toBe([])
      });
    });
    
  });
  
});