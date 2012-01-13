define('testdir/models/contact.spec', function(require) {
  
  require('ember');
  require('data');
  var RadiumAdapter = require('core/adapter');
  var Radium = require('radium');
  require('models/address');
  require('models/user');
  require('models/contact');
  
  var get = Ember.get, set = Ember.set, getPath = Ember.getPath;

  var USER_FIXTURE = {user: {
    id: 100,
    name: "Jimmy McNulty",
    phone: "+1 410 555-5555",
    contacts: [1]
  }};

  var CONTACT_FIXTURE = {contact: {
        id: 1,
        name: "Stringer Bell",
        user: 100,
        addresses: [
                    {
                      id: 8,
                      name: "Address 1",
                      street: "03284 Johnson Center",
                      state: "Illinois",
                      country: "United States",
                      zip_code: "39645",
                      time_zone: null
                    }
                  ],
        phone_numbers: [
                    {
                      id: 282,
                      created_at: "2011-12-14T16:35:15Z",
                      updated_at: "2011-12-14T16:35:15Z",
                      name: "Phone Number",
                      value: "+52313872481",
                      accepted_values: null
                  }],
        email_addresses: [{
                    id: 281,
                    created_at: "2011-12-14T16:35:15Z",
                    updated_at: "2011-12-14T16:35:15Z",
                    name: "Email",
                    value: "email-1@example.com",
                    accepted_values: null,
                  }],
        fields: []
      }
  }
    
  describe("Radium#Contact", function() {
    
    it("inherits from Radium.Person", function() {
      expect(Radium.Person.detect(Radium.Contact)).toBeTruthy();
    });
    
    describe("creating a new contact", function() {
      
      beforeEach(function() {
        this.contact = Radium.Contact.create(CONTACT_FIXTURE.contact)
      });
      
      afterEach(function() {
        this.contact.destroy();
      });
      
      it("creates a user", function() {
        expect(this.contact).toBeDefined();
      });
      
      it("loads and processes their name", function() {
        expect(this.contact.get('name')).toBe("Stringer Bell");
        expect(this.contact.get('firstName')).toBe("Stringer");
        expect(this.contact.get('abbrName')).toBe("Stringer B.");
      });
    
    });

    describe("when making RESTful API requests and talks with the datastore", function() {
      var adapter, store, server;

      beforeEach(function() {
        adapter = RadiumAdapter.create();
        store = DS.Store.create({adapter: adapter});
        server = sinon.fakeServer.create();
      });
      
      afterEach(function() {
        adapter.destroy();
        store.destroy();
        server.restore();
        jQuery.ajax.restore();
      });

      it("loads a user that exists", function() {
        var spy, contact;
        
        spy = sinon.spy(jQuery, 'ajax');

        server.respondWith("GET", "/contacts/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(CONTACT_FIXTURE)
        ]);
        
        contact = store.find(Radium.Contact, 1);
        server.respond();
          
        expect(spy).toHaveBeenCalled();
        expect(contact.get('name')).toBe("Stringer Bell");
      });
      
    });

    describe("when nested attributes are requested", function() {
      beforeEach(function() {
        adapter = RadiumAdapter.create();
        store = DS.Store.create({adapter: adapter});
        server = sinon.fakeServer.create();
      });
      
      afterEach(function() {
        adapter.destroy();
        store.destroy();
        server.restore();
        jQuery.ajax.restore();
      });

      it("loads nested Radium.Address", function() {
        var spy, contact;
        
        spy = sinon.spy(jQuery, 'ajax');

        server.respondWith("GET", "/contacts/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(CONTACT_FIXTURE)
        ]);

        contact = store.find(Radium.Contact, 1);
        server.respond();
        
        expect(spy).toHaveBeenCalled();
        expect(contact.get('addresses').objectAt(0).get('id')).toEqual(8);
      });

      it("loads nested Radium.PhoneNumber", function() {
        var spy, contact;
        
        spy = sinon.spy(jQuery, 'ajax');

        server.respondWith("GET", "/contacts/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(CONTACT_FIXTURE)
        ]);

        contact = store.find(Radium.Contact, 1);
        server.respond();
        
        expect(spy).toHaveBeenCalled();
        expect(contact.get('phoneNumbers').objectAt(0).get('id')).toEqual(282);
      });

      it("loads nested Radium.PhoneNumber", function() {
        var spy, contact;
        
        spy = sinon.spy(jQuery, 'ajax');

        server.respondWith("GET", "/contacts/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(CONTACT_FIXTURE)
        ]);

        contact = store.find(Radium.Contact, 1);
        server.respond();
        
        expect(spy).toHaveBeenCalled();
        expect(contact.get('emailAddresses').objectAt(0).get('id')).toEqual(281);
      });
    });
    
  });
  
});