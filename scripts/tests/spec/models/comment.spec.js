define('testdir/models/comment.spec', function() {

  var RadiumAdapter = require('adapter'),
      Radium = require('radium');


  describe("Radium#Comment", function() {

    it("inherits from Radium.Core", function() {
      expect(Radium.Core.detect(Radium.Comment)).toBeTruthy();
    });

    xit("adds an attachment", function() {
      var comment, attachment,
          adapter = RadiumAdapter.create(),
          store = DS.Store.create({adapter: adapter});
      
      attachment = store.createRecord(Radium.Attachment, {});

      store.createRecord(Radium.Comment, {
        text: "Look at this attachment"
      });
    });
    
    describe("when adding a specific comment type", function() {
      var adapter, store, server, spy, commentFixture;

      beforeEach(function() {
        adapter = RadiumAdapter.create();
        store = DS.Store.create({adapter: adapter});
        server = sinon.fakeServer.create();
        spy = sinon.spy(jQuery, 'ajax');

        commentFixture = {
              id: 7,
              created_at: "2011-12-14T13:25:36Z",
              updated_at: "2011-12-14T13:25:36Z",
              text: "This drug thing, this ain't police work.",
              user: 468,
              attachments: []
            };

        store.load(Radium.User, {
          id: 468,
          name: "Bunny Colvin"
        });
      });
      
      afterEach(function() {
        adapter.destroy();
        store.destroy();
        server.restore();
        jQuery.ajax.restore();
      });

      it("adds to a Todo comment", function() {
        store.load(Radium.Todo, {
            id: 55,
            contacts: [],
            comments: [],
            user: 468
          });

        var comment = store.createRecord(Radium.Comment, {
          text: "This drug thing, this ain't police work.",
          _type: 'todo',
          user: 468,
          reference: 55
        });

        var todo = store.find(Radium.Todo, 55);
        var user = store.find(Radium.User, 468);

        todo.get('comments').pushObject(comment);

        server.respondWith(
          'POST', '/todos/55/comments', [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(commentFixture)
        ]);
        
        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toBe('/todos/55/comments');
        expect(todo.getPath('comments.length')).toEqual(1);
      });

      it("adds to a Deal comment", function() {
        store.load(Radium.Deal, {
            id: 55,
            contacts: [],
            comments: [],
            user: 468
          });

        var comment = store.createRecord(Radium.Comment, {
          text: "This drug thing, this ain't police work.",
          _type: 'deal',
          user: 468,
          reference: 55
        });

        var deal = store.find(Radium.Deal, 55);
        var user = store.find(Radium.User, 468);

        deal.get('comments').pushObject(comment);

        server.respondWith(
          'POST', '/deals/55/comments', [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(commentFixture)
        ]);
        
        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toBe('/deals/55/comments');
        expect(deal.getPath('comments.length')).toEqual(1);
      });

      it("adds to a Meeting comment", function() {
        store.load(Radium.Meeting, {
            id: 55,
            contacts: [],
            comments: [],
            user: 468
          });

        var comment = store.createRecord(Radium.Comment, {
          text: "This drug thing, this ain't police work.",
          _type: 'meeting',
          user: 468,
          reference: 55
        });

        var meeting = store.find(Radium.Meeting, 55);
        var user = store.find(Radium.User, 468);

        meeting.get('comments').pushObject(comment);

        server.respondWith(
          'POST', '/meetings/55/comments', [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(commentFixture)
        ]);
        
        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toBe('/meetings/55/comments');
        expect(meeting.getPath('comments.length')).toEqual(1);
      });

      it("adds to a PhoneCall comment", function() {
        store.load(Radium.PhoneCall, {
            id: 55,
            contacts: [],
            comments: [],
            user: 468
          });

        var comment = store.createRecord(Radium.Comment, {
          text: "This drug thing, this ain't police work.",
          _type: 'phone_call',
          user: 468,
          reference: 55
        });

        var call = store.find(Radium.PhoneCall, 55);
        var user = store.find(Radium.User, 468);

        call.get('comments').pushObject(comment);

        server.respondWith(
          'POST', '/phone_calls/55/comments', [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(commentFixture)
        ]);
        
        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toBe('/phone_calls/55/comments');
        expect(call.getPath('comments.length')).toEqual(1);
      });

      it("adds to a Messages comment", function() {
        store.load(Radium.Message, {
            id: 55,
            contacts: [],
            comments: [],
            user: 468
          });

        var comment = store.createRecord(Radium.Comment, {
          text: "This drug thing, this ain't police work.",
          _type: 'message',
          user: 468,
          reference: 55
        });

        var message = store.find(Radium.Message, 55);
        var user = store.find(Radium.User, 468);

        message.get('comments').pushObject(comment);

        server.respondWith(
          'POST', '/messages/55/comments', [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(commentFixture)
        ]);
        
        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toBe('/messages/55/comments');
        expect(message.getPath('comments.length')).toEqual(1);
      });

      it("adds to a Activities comment", function() {
        store.load(Radium.Activity, {
            id: 55,
            comments: [],
            user: 468
          });

        var comment = store.createRecord(Radium.Comment, {
          text: "This drug thing, this ain't police work.",
          _type: 'activity',
          user: 468,
          reference: 55
        });

        var activity = store.find(Radium.Activity, 55);
        var user = store.find(Radium.User, 468);

        activity.get('comments').pushObject(comment);

        server.respondWith(
          'POST', '/activities/55/comments', [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(commentFixture)
        ]);
        
        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toBe('/activities/55/comments');
        expect(activity.getPath('comments.length')).toEqual(1);
      });


    });
  });
});