describe("Radium#PhoneCall", function() {
    var FIXTURE = {
        id: 8,
        created_at: "2011-12-15T14:26:39Z",
        updated_at: "2011-12-15T14:26:39Z",
        outcome: null,
        duration: 600,
        kind: "accepted",
        dialed_at: "2011-12-08T13:01:51Z",
        to: [
          { 
            "id": 55,
            "to_type": "User"
          }
        ],
        from: [
          { 
            "id": 25,
            "from_type": "Contact"
          }
        ],
        contacts: [25],
        users: [55],
        comments: [],
        todos: []
      };
    
    var USER = {
      id: 55,
      name: "Stringer Bell"
    }

    var CONTACT = {
      id: 25,
      name: "D'Angelo Barksdale"
    }
  
  it("inherits from Radium.Core", function() {
    expect(Radium.Core.detect(Radium.PhoneCall)).toBeTruthy();
  });


  describe("when talking with the API", function() {
    var adapter, store, server, spy;

    beforeEach(function() {
      adapter = DS.RadiumAdapter.create();
      store = DS.Store.create({revision: 3,adapter: adapter});
      server = sinon.fakeServer.create();
      spy = sinon.spy(jQuery, 'ajax');
    });
    
    afterEach(function() {
      adapter.destroy();
      store.destroy();
      server.restore();
      jQuery.ajax.restore();
    });

    it("loads a new PhoneCall", function() {
      var call;

      store.load(Radium.PhoneCall, FIXTURE);

      call = store.find(Radium.PhoneCall, 8);

      expect(call).toBeDefined();
      expect(call.get('id')).toEqual(8);
      expect(call.get('callTo')).toEqual([55])
      expect(call.get('callFrom')).toEqual([25])
    });

    it("updates the outcome", function() {
      var call;

      server.fakeHTTPMethods = true;
      server.respondWith(
        'POST', '/api/phone_calls/8', [
        200,
        {"Content-Type": "application/json"},
        JSON.stringify(
          jQuery.extend(FIXTURE, {outcome: 'follow_up_required'})
        )
      ]);

      store.load(Radium.PhoneCall, FIXTURE);

      call = store.find(Radium.PhoneCall, 8);
      call.set('outcome', 'follow_up_required');

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/phone_calls/8');
      expect(call.get('outcome')).toBe('follow_up_required');
    });
  });
});