describe("Radium#Meeting", function() {

  it("inherits from Radium.Core", function() {
    expect(Radium.Core.detect(Radium.Meeting)).toBeTruthy();
  });

  var CREATE_MEETING = {
        id: 2,
        created_at: "2011-12-28T14:26:26Z",
        updated_at: "2011-12-28T14:26:26Z",
        topic: "Stringer Bell",
        location: "Police station basement",
        starts_at: "2011-12-28T15:26:22Z",
        ends_at: "2011-12-28T16:26:22Z",
        user: 5,
        contacts: [12],
        users: [29, 44],
        activities: [32],
        invitations: [
          {
            id: 300,
            created_at: "2011-12-28T14:26:26Z",
            updated_at: "2011-12-28T14:26:26Z",
            state: "pending",
            hash_key: "f9e7128044e00d3f7cd881fe76a3b079c8450c09",
            meeting: 2,
            user: 29
          },
          {
            id: 301,
            created_at: "2011-12-28T14:26:26Z",
            updated_at: "2011-12-28T14:26:26Z",
            state: "pending",
            hash_key: "f9e7128044e00d3f7cd881fe76a3b079c8450c09",
            meeting: 2,
            user: 44
          },
          {
            id: 302,
            created_at: "2011-12-28T14:26:26Z",
            updated_at: "2011-12-28T14:26:26Z",
            state: "pending",
            hash_key: "f9e7128044e00d3f7cd881fe76a3b079c8450c09",
            meeting: 2,
            contact: 12
          }
        ]
      };

  var meetingCreator = {
    id: 5,
    name: "Jimmy McNulty",
    meetings: []
  };

  var invitedUser1 = {
    id: 44,
    name: "Kima Greggs",
    meetings: []
  };

  var invitedUser2 = {
    id: 29,
    name: "Bunk Moreland",
    meetings: []
  };

  var invitedContact = {
    id: 12,
    name: "Reginal Cousins",
    meetings: []
  };

  describe("when talking with the API", function() {
    var adapter, store, server, spy;

    beforeEach(function() {
      adapter = RadiumAdapter.create({bulkCommit: false});
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

    it("creates a meeting", function() {
      var meeting, invitation, contacts, users;

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/api/meetings", [
        200,
        {"Content-Type": "application/json"},
        JSON.stringify(CREATE_MEETING)
      ]);

      users = store.loadMany(Radium.User, [
        meetingCreator, 
        invitedUser1,
        invitedUser2
      ]);

      contacts = store.loadMany(Radium.Contact, [invitedContact]);

      meeting = store.createRecord(Radium.Meeting, {
        topic: "Stringer Bell",
        location: "Police station basement",
        startsAt: "2011-12-28T15:26:22Z",
        endsAt: "2011-12-28T16:26:22Z",
        invite: [
          'bunk@baltimorepolice.org',
          'greggs@baltimorepolice.org',
          'equivocatingmuthafucka@hotmail.com' //Bubbles ;-)
        ]
      });

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(meeting.get('users').getEach('id'))
        .toEqual([29, 44]);
      expect(meeting.get('contacts').getEach('id'))
        .toEqual([12]);
    });

    it("reschedules a meeting", function() {
      var meeting,
          newStartAt = "2012-01-30T15:00:00Z",
          newEndsAt = "2012-01-30T15:00:00Z";
      
      server.fakeHTTPMethods = true;
      server.respondWith(
        "PUT", "/api/meetings/2/reschedule", [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(
            jQuery.extend(
              CREATE_MEETING,
              {
                starts_at: newStartAt,
                ends_at: newEndsAt
              }
            )
          )
        ]
      );

      store.load(Radium.Meeting, CREATE_MEETING);

      meeting = store.find(Radium.Meeting, 2);
      meeting.set('startsAt', newStartAt);

      store.commit();
      server.respond();
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/meetings/2/reschedule');
      expect(meeting.get('startsAt')).toEqual(new Date(newStartAt));
    });

    it("cancels a meeting", function() {
      var meeting;

      server.fakeHTTPMethods = true;
      server.respondWith(
        "PUT", "/api/meetings/2/cancel", [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(
            jQuery.extend(CREATE_MEETING, {cancelled: true})
          )
        ]
      );

      store.load(Radium.Meeting, CREATE_MEETING);
      meeting = store.find(Radium.Meeting, 2);
      meeting.set('cancelled', true);

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe("/api/meetings/2/cancel")
    });
  });
});