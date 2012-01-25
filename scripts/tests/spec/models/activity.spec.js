define(function(require) {

  var RadiumAdapter = require('adapter'),
    Radium = require('radium');


  var ACTIVITY = {
      id: 53,
      created_at: "2011-12-28T14:26:27Z",
      updated_at: "2011-12-28T14:26:27Z",
      tags: ["tags", "describing", "what", "action", "happened"],
      timestamp: "2011-12-28T14:26:27Z",
      owner: {
        user: {
          id: 46,
          created_at: "2011-12-28T14:26:27Z",
          updated_at: "2011-12-28T14:26:27Z",
          name: "Omar Little",
          email: "irobsdrugsdealers@hotmail.com",
          phone: "+1410333-3321",
          is_public: true,
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

  describe("Radium#Activity", function() {
    var adapter, store, server, spy;

    beforeEach(function() {
      adapter = RadiumAdapter.create();
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
    
    it("inherits from Radium.Core", function() {
      expect(Radium.Core.detect(Radium.Activity)).toBeTruthy();
    });

    describe("when getting a nested reference", function() {
      var activity;

      beforeEach(function() {
        store.load(Radium.Activity, ACTIVITY);
        store.loadMany(Radium.Deal, [
          {id: 65, description: "Testing 123"},
          {id: 11, description: "Testing 123"},
        ]);
        store.loadMany(Radium.Contact, [
          {id: 33, name: "Testing 123"},
          {id: 44, name: "Testing 123"},
          {id: 55, name: "Testing 123"}
        ]);
        activity = store.find(Radium.Activity, 53);
      });

      afterEach(function() {

      });

      it("loads an embedded user", function() {
        var owner = activity.get('owner');
        expect(activity.getPath('owner.id')).toEqual(46);
        expect(activity.getPath('owner.name')).toBe('Omar Little');
        expect(activity.getPath('owner.abbrName')).toBe('Omar L.');
        expect(store.find(Radium.User, 46)).toEqual(owner);
      });

      it("loads an embedded user", function() {
        expect(activity.getPath('owner.deals.length')).toEqual(2);
        expect(activity.getPath('owner.deals').getEach('id'))
              .toEqual([65, 11]);
      });
      
      it("loads an embedded activity", function() {
        expect(activity.getPath('reference.id')).toEqual(3);
      });

      it("loads an embedded activity's contacts", function() {
        expect(activity.getPath('reference.contacts.length')).toEqual(3);
        expect(activity.getPath('reference.contacts').getEach('id'))
              .toEqual([33, 44, 55]);
        expect(activity.getPath('reference.contacts').getEach('name'))
              .toEqual(["Testing 123", "Testing 123", "Testing 123"]);
      });

    });

    describe("when sorting by date", function() {
      var activity;

      beforeEach(function() {
        store.loadMany(Radium.Activity, [
          {id: 100, timestamp: "2012-01-12T14:26:27Z"},
          {id: 101, timestamp: "2012-03-25T14:26:27Z"},
          {id: 102, timestamp: "2012-05-08T14:26:27Z"},
          {id: 103, timestamp: "2012-07-30T14:26:27Z"},
          {id: 104, timestamp: "2012-08-17T14:26:27Z"},
          {id: 105, timestamp: "2011-12-04T14:26:27Z"}
        ]);
        activities = store.findAll(Radium.Activity);
      });

      it("computes the days", function() {
        expect(activities.getEach('day'))
          .toEqual(['12', '25', '08', '30', '17', '04']);
      });

      it("computes the months", function() {
        expect(activities.getEach('month'))
            .toEqual(['01', '03', '05', '07', '08', '12']);
      });

      it("computes the years", function() {
        expect(activities.getEach('year'))
          .toEqual(['2012','2012','2012','2012','2012','2011']);
      });
    });
  });
  
});