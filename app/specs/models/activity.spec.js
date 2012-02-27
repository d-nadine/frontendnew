describe("Radium#Activity", function() {
    var ACTIVITY = {
    id: 53,
    created_at: "2011-12-28T14:26:27Z",
    updated_at: "2011-12-28T14:26:27Z",
    tags: ["todo", "assigned"],
    timestamp: "2011-12-28T14:26:27Z",
    owner: {
      id: 1312312,
      user: {
        id: 46,
        created_at: "2011-12-28T14:26:27Z",
        updated_at: "2011-12-28T14:26:27Z",
        name: "Omar Little",
        email: "irobsdrugsdealers@hotmail.com",
        phone: "+1410333-3321",
        public: true,
        contacts: [33, 44],
        deals: [65, 11],
        campaigns: [],
        following: [],
        followers: [],
        todos: [],
        meetings: [],
        reminders: [],
        notes: [],
        phone_calls: [],
        ims: [],
        emails: [],
        sms: [],
        activities: [],
        account: 1
      }
    },
    reference: {
      id: 34123131,
      todo: {
        id: 3,
        created_at: "2011-12-28T14:26:27Z",
        updated_at: "2011-12-28T14:26:27Z",
        kind: "general",
        description: "Finish programming radium",
        finish_by: "2012-01-04T14:26:22Z",
        contacts: [33, 44, 55],
        comments: [],
        activities: [51, 52],
        user: 45,
        reference: null
      }
    }
  };
  
  var adapter, store, server, spy;

  beforeEach(function() {
    adapter = RadiumAdapter.create();
    store = DS.Store.create({revision: 1,adapter: adapter});
    server = sinon.fakeServer.create();
    spy = sinon.spy(jQuery, 'ajax');
  });
  
  afterEach(function() {
    adapter.destroy();
    store.destroy();
    server.restore();
    jQuery.ajax.restore();
  });
  
  it("inherits from Radium.Core", function() {
    expect(Radium.Core.detect(Radium.Activity)).toBeTruthy();
  });

  describe("when processing computed values", function() {
    beforeEach(function() {
      store.load(Radium.Activity, ACTIVITY);
    });

    afterEach(function() {
    
    });

    it("computes the activity type", function() {
      var activity = store.find(Radium.Activity, 53);
      expect(activity.get('type')).toBe('todo');
    });
  });

  describe("when getting a nested reference", function() {
    var activity;

    beforeEach(function() {
      store.load(Radium.Activity, {
        id: 53,
        owner: {
          id: 'R31241',
          user: {
            id: 77,
            deals: [65, 11],
            contacts: [33, 44]
          }
        },
        reference: {
          id: 'R31341',
          todo: {
            id: 11
          }
        }
      });
      activity = store.find(Radium.Activity, 53);
    });

    afterEach(function() {

    });

    it("loads an embedded user", function() {
      expect(activity.getPath('owner.user.id')).toEqual(77);
    });

    it("loads an embedded user's deals", function() {
      // FIXME: Simulate fetching nested activities
      // server.respondWith("GET", "/api/deals", [
      //   200, {"Content-Type": "application/json"},
      //   JSON.stringify([{id: 65},{id: 11}])
      // ]);

      var deals = activity.getPath('owner.user.deals');
      
      server.respond();
      expect(spy).toHaveBeenCalled();
      expect(deals.get('length')).toEqual(2);
      // expect(deals.getEach('id')).toEqual([65, 11]);
    });
    
    it("loads an embedded activity", function() {
      expect(activity.getPath('reference.todo.id')).toEqual(11);
    });

  });

  describe("when sorting by date", function() {
    var activity;

    beforeEach(function() {
      store.loadMany(Radium.Activity, [
        {id: 100, updated_at: "2012-01-12T14:26:27Z"},
        {id: 101, updated_at: "2012-03-25T14:26:27Z"},
        {id: 102, updated_at: "2012-05-08T14:26:27Z"},
        {id: 103, updated_at: "2012-07-30T14:26:27Z"},
        {id: 104, updated_at: "2012-08-17T14:26:27Z"},
        {id: 105, updated_at: "2011-12-04T14:26:27Z"}
      ]);
      activities = store.findAll(Radium.Activity);
    });

    it("computes the day", function() {
      expect(activities.objectAt(0).get('day')).toBe('2012-01-12');
    });

    it("computes the week", function() {
      expect(activities.objectAt(0).get('week')).toBe('2012-02');
      expect(activities.getPath('lastObject.week')).toBe('2011-48');
    });

    it("computes the month", function() {
      expect(activities.objectAt(1).get('month')).toBe('2012-03');
    });

    it("computes the quarter", function() {
      expect(activities.objectAt(0).get('quarter')).toBe('2012-Q1');
      expect(activities.objectAt(2).get('quarter')).toBe('2012-Q2');
    });

    it("computes the year", function() {
      expect(activities.getPath('lastObject.year')).toBe('2011');
    });
  });
});