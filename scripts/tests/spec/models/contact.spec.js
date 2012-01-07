define('testdir/models/contact.spec', function(require) {
  
  require('ember');
  require('data');
  require('radium');
  require('models/contact');
  
  Radium.Contact.FIXTURES = [];
  
  describe("Radium#Contact", function() {
    
    it("inherits from Radium.Person", function() {
      expect(Radium.Person.detect(Radium.Contact)).toBeTruthy();
    });
    
    describe("creating a new contact", function() {
      
      beforeEach(function() {
        this.store = DS.Store.create({adapter: 'DS.fixtureAdapter'});
        
        this.store.createRecord(Radium.Contact, {
          "id": 1,
          "name": "Johnny Graham"
        })
      });
      
      afterEach(function() {
        this.store.destroy();
      });
      
      it("creates a user", function() {
        expect(this.store.findAll(Radium.Contact).get('length')).toBe(1);
      });
      
      it("loads and processes their name", function() {
        var person = this.store.find(Radium.Contact, 1);
        expect(person.get('name')).toBe("Johnny Graham");
        expect(person.get('firstName')).toBe("Johnny");
        expect(person.get('abbrName')).toBe("Johnny G.");
      });
      
    });
    
  });
  
});