define('testdir/models/invitation.spec', function(require) {
  var RadiumAdapter = require('adapter'),
      Radium = require('radium');
  
  describe("Radium#Invitation", function() {

    it("inherits from Radium.Core", function() {
      expect(Radium.Core.detect(Radium.Invitation)).toBeTruthy();
    });

    var MEETING = {
          id: 2,
          created_at: "2011-12-28T14:26:26Z",
          updated_at: "2011-12-28T14:26:26Z",
          topic: "I'm faking a serial killer.",
          location: "A homeless man murder crime scene",
          starts_at: "2011-12-28T15:26:22Z",
          ends_at: "2011-12-28T16:26:22Z",
          user: 5,
          contacts: [],
          users: [5],
          activities: [],
          invitations: [
            {
              id: 241,
              created_at: "2011-12-28T14:26:26Z",
              updated_at: "2011-12-28T14:26:26Z",
              state: "pending",
              hash_key: "8a0e49cd3b18d49a565fe91211e66462f8104114",
              meeting: 1,
              user: 2
            }
          ]
        };
    
    var INVITE = {
          id: 241,
          created_at: "2011-12-28T14:26:26Z",
          updated_at: "2011-12-28T14:26:26Z",
          state: "pending",
          hash_key: "8a0e49cd3b18d49a565fe91211e66462f8104114",
          meeting: 1,
          user: 2
        };

    var meetingCreator = {
      id: 5,
      name: "Jimmy McNulty",
      meetings: [2]
    };

    var invitedUser = {
      id: 29,
      name: "Bunk Moreland",
      meetings: []
    };

    describe("when talking with the API", function() {
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

      xit("accepts an invite to a meeting", function() {
        var meeting;
        
        server.fakeHTTPMethods = true;
        server.respondWith(
          "PUT", "/invitations/2/confirm", [
            200,
            {"Content-Type": "application/json"},
            JSON.stringify(
              jQuery.extend(
                MEETING,
                {invitations: {state: "confirm"}}
              )
            )
          ]
        );

        store.load(Radium.Meeting, MEETING);

        meeting = store.find(Radium.Meeting, 2);
        meeting.get('invitations').objectAt(0).set('state', 'confirm');
        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toBe('/invitations/2/confirm');
      });

      xit("cancels a meeting", function() {
        var meeting;

        server.fakeHTTPMethods = true;
        server.respondWith(
          "PUT", "/invitations/2/cancel", [
            200,
            {"Content-Type": "application/json"},
            JSON.stringify(
              jQuery.extend(
              MEETING,
                {invitations: {state: "cancelled"}}
              )
            )
          ]
        );

        store.load(Radium.Meeting, MEETING);

        meeting = store.find(Radium.Meeting, 2);
        meeting.get('invitations').objectAt(0).set('state', 'reject');

        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toBe('/invitations/2/reject');
      });
    });
  });

});