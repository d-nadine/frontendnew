define(function(require) {

  var RadiumAdapter = require('adapter'),
    Radium = require('radium');


  var ACTIVITY = {
      id: 53,
      created_at: "2011-12-28T14:26:27Z",
      updated_at: "2011-12-28T14:26:27Z",
      tags: ["tags", "describing", "what", "action", "happened"],
      timestamp: "2011-12-28T14:26:27Z",
      test: {
        id: 1211,
        name: 'asdf'
      },
      owner: {
        user: {
          id: 46,
          created_at: "2011-12-28T14:26:27Z",
          updated_at: "2011-12-28T14:26:27Z",
          name: "Omar Little",
          email: "irobsdrugsdealers@hotmail.com",
          phone: "+1410333-3321",
          is_public: true,
          contacts: [],
          deals: [],
          campaigns: [],
          following: [],
          followers: [],
          todos: [10, 11, 12],
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
          contacts: [],
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
        activity = store.find(Radium.Activity, 53);
      });

      it("loads an embedded user", function() {
        expect(activity.getPath('owner.id')).toEqual(46);
        expect(activity.getPath('owner.name')).toBe('Omar Little');
        expect(activity.getPath('owner.abbrName')).toBe('Omar L.');
      });

      it("loads an embedded activity", function() {
        expect(activity.getPath('reference.id')).toEqual(3);
      });
    });
  });
  
});