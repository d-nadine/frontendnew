define(function(require) {
  
  var Radium = require('radium');

  var CREATE_FIXTURE = {
    id: 31,
    created_at: "2011-12-15T09:37:23Z",
    updated_at: "2011-12-15T09:37:23Z",
    description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.",
    close_by: "2011-12-22T09:37:23Z",
    line_items: [
      {
        name: "Radium",
        quantity: 1,
        price: "1000.0",
        currency: "USD",
      },
      {
        quantity: 1,
        product_id: 5
      }
    ],
    contact_id: 151,
    user_id: 460,
    line_items: [
      {
        id: 34,
        name: "Radium",
        quantity: 1,
        price: "1000.0",
        currency: "USD",
        product: null
      }
    ],
    todos: [],
    comments: [],
    products: [],
    activities: []
  };

  describe("Radium#Deal", function() {
    
    it("inherits from Radium.Person", function() {
      expect(Radium.Core.detect(Radium.Deal)).toBeTruthy();
    });

    describe("when a deal is overdue", function() {
      var adapter, store;

      it("marks the deal as overdue", function() {
        var today = new Date();
        adapter = DS.RESTAdapter.create();
        store = DS.Store.create({adapter: adapter});

        store.load(Radium.Deal, CREATE_FIXTURE);

        expect(store.find(Radium.Deal, 31).get('isOverdue')).toBeTruthy();
      });
    });

    describe("when talking with the API", function() {
      var adapter, store, server, spy;

      beforeEach(function() {
        adapter = DS.RESTAdapter.create();
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

      it("creates a new Deal", function() {
        server.fakeHTTPMethods = true;
        server.respondWith(
          "POST", "/deals", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify({deals: [CREATE_FIXTURE]})
        ]);

        store.createRecord(Radium.Deal, {
          description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.",
          close_by: "2011-12-22T09:37:23Z",
          line_items_attributes: [
            {
              name: "Radium",
              quantity: 1,
              price: "1000.0",
              currency: "USD",
            },
            {
              quantity: 1,
              product_id: 5
            }
          ],
          contact_id: 151,
          user_id: 460
        });

        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(server.requests[0].method).toEqual("POST");
        expect(store.models.length).toEqual(1);
        expect(store.find(Radium.Deal, 31)).toBeDefined();
      });
    });

  });

});