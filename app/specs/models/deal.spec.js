describe("Radium#Deal", function() {
  var CREATE_FIXTURE = {
    id: 31,
    state: 'pending',
    created_at: "2011-12-15T09:37:23Z",
    updated_at: "2011-12-15T09:37:23Z",
    description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.",
    close_by: "2011-12-22T09:37:23Z",
    line_items: [
      {
        id: 34,
        name: "Radium",
        quantity: 1,
        price: "1000.0",
        currency: "USD",
        product: null
      },
      {
        id: 33,
        name: "Radium",
        quantity: 1,
        price: "1000.0",
        currency: "USD",
        product: null
      },
      {
        id: 32,
        name: "Radium",
        quantity: 1,
        price: "1000.0",
        currency: "USD",
        product: null
      }
    ],
    contact_id: 151,
    user_id: 460,
    todos: [],
    comments: [],
    products: [],
    activities: []
  };
  
  it("inherits from Radium.Core", function() {
    expect(Radium.Core.detect(Radium.Deal)).toBeTruthy();
  });

  describe("when a deal is overdue", function() {
    var adapter, store;

    it("marks the deal as overdue", function() {
      var today = new Date();
      adapter = Radium.Adapter.create();
      store = DS.Store.create({adapter: adapter});

      store.load(Radium.Deal, CREATE_FIXTURE);

      expect(store.find(Radium.Deal, 31).get('isOverdue')).toBeTruthy();
    });
  });

  describe("when talking with the API", function() {
    var adapter, store, server, spy;

    beforeEach(function() {
      adapter = Radium.Adapter.create();
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
        JSON.stringify(CREATE_FIXTURE)
      ]);

      var deal = store.createRecord(Radium.Deal, {
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
        user_id: 460
      });

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(server.requests[0].method).toEqual("POST");
      expect(store.find(Radium.Deal, 31)).toBeDefined();
    });

    it("validates the Deal state", function() {
      var deal;

      store.load(Radium.Deal, CREATE_FIXTURE);
      deal = store.find(Radium.Deal, 31);

      expect(deal.get('state')).toBe('pending');

      deal.set('state', 'asdf');

      expect(deal.get('state')).toEqual('pending')
    });

    it("creates LineItems from embedded data", function() {
      var deal;

      store.load(Radium.Deal, CREATE_FIXTURE);
      deal = store.find(Radium.Deal, 31);

      expect(deal.getPath('lineItems.length')).toEqual(3);
    });

    it("calculates a total of all deal line items", function() {
      var deal;

      store.load(Radium.Deal, CREATE_FIXTURE);
      deal = store.find(Radium.Deal, 31);
      expect(deal.get('dealTotal')).toEqual(3000);
    });

    // TODO: Once updating nested stores work, implement this test.
    xit("updates the total price when a LineItem is added", function() {
      var deal, fixture, lineItemFixture, lineItem;

      lineItemFixture = {
        name: "Radium",
        quantity: 1,
        price: "1500.0",
        currency: "USD",
        product: null
      };

      fixture = CREATE_FIXTURE;
      
      fixture.line_items.push(jQuery.extend({id: 35}, lineItemFixture));

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/deals/31", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify(fixture)
      ]);

      store.load(Radium.Deal, CREATE_FIXTURE);
      deal = store.find(Radium.Deal, 31);
      lineItem = store.createRecord(Radium.LineItem, lineItemFixture);
      deal.get('lineItems').pushObject(lineItemFixture);

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(deal.getPath('line_items.length')).toEqual(4);
      expect(deal.get('dealTotal')).toEqual(4500);
    });
  });

});