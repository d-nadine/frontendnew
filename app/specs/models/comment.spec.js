describe("Radium#Comment", function() {

  it("inherits from Radium.Core", function() {
    expect(Radium.Core.detect(Radium.Comment)).toBeTruthy();
  });

  describe("when updating or adding a comment", function() {
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

    it("updates a comment", function() {
      var comment,
          newText = "I mean, you call something a war and pretty soon everybody gonna be running around acting like warriors.";

      server.respondWith('POST', '/api/todos/55/comments', [
        200,
        {"Content-Type": "application/json"},
        JSON.stringify({
          id: 13,
          text: newText
        })
      ]);

      store.load(Radium.Comment, {
        id: 13,
        text: "This drug thing, this ain't police work."
      });

      comment = store.find(Radium.Comment, 13);

      comment.set('text', newText);

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/comments/13');
      expect(comment.get('text')).toBe(newText);
    });

    xit("adds an attachment", function() {
      var comment, attachment;
              
      attachment = store.createRecord(Radium.Attachment, {});

      store.createRecord(Radium.Comment, {
        text: "Look at this attachment"
      });
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

      var todo = store.find(Radium.Todo, 55);
      var user = store.find(Radium.User, 468);
      var comment = store.createRecord(Radium.Comment, {
        text: "This drug thing, this ain't police work.",
        user: 468,
        relation: 55
      });

      Radium.Comment.reopenClass({
        url: "todos/" + todo.get('id') + "/comments"
      });


      server.respondWith(
        'POST', '/api/todos/55/comments', [
        200,
        {"Content-Type": "application/json"},
        JSON.stringify(commentFixture)
      ]);
      
      store.commit();
      server.respond();

      todo.get('comments').pushObject(comment);
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/todos/55/comments');
      expect(todo.getPath('comments.length')).toEqual(1);
    });

    it("adds to a Deal comment", function() {
      store.load(Radium.Deal, {
          id: 55,
          contacts: [],
          comments: [],
          user: 468
        });


      var deal = store.find(Radium.Deal, 55);
      var user = store.find(Radium.User, 468);
      var comment = store.createRecord(Radium.Comment, {
        text: "This drug thing, this ain't police work.",
        user: 468
      });

      Radium.Comment.reopenClass({
        url: "deals/" + deal.get('id') + "/comments"
      });


      server.respondWith(
        'POST', '/api/deals/55/comments', [
        200,
        {"Content-Type": "application/json"},
        JSON.stringify(commentFixture)
      ]);
      
      store.commit();
      server.respond();

      deal.get('comments').pushObject(comment);
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/deals/55/comments');
      expect(deal.getPath('comments.length')).toEqual(1);
    });

    it("adds to a Meeting comment", function() {
      store.load(Radium.Meeting, {
          id: 55,
          contacts: [],
          comments: [],
          user: 468
        });


      var meeting = store.find(Radium.Meeting, 55);
      var user = store.find(Radium.User, 468);
      var comment = store.createRecord(Radium.Comment, {
        text: "This drug thing, this ain't police work.",
        user: 468
      });

      Radium.Comment.reopenClass({
        url: "meetings/" + meeting.get('id') + "/comments"
      });


      server.respondWith(
        'POST', '/api/meetings/55/comments', [
        200,
        {"Content-Type": "application/json"},
        JSON.stringify(commentFixture)
      ]);
      
      store.commit();
      server.respond();

      meeting.get('comments').pushObject(comment);
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/meetings/55/comments');
      expect(meeting.getPath('comments.length')).toEqual(1);
    });

    it("adds to a PhoneCall comment", function() {
      store.load(Radium.PhoneCall, {
          id: 55,
          contacts: [],
          comments: [],
          user: 468
        });

      var call = store.find(Radium.PhoneCall, 55);
      var user = store.find(Radium.User, 468);
      var comment = store.createRecord(Radium.Comment, {
        text: "This drug thing, this ain't police work.",
        user: 468
      });

      Radium.Comment.reopenClass({
        url: "phone_calls/" + call.get('id') + "/comments"
      });


      server.respondWith(
        'POST', '/api/phone_calls/55/comments', [
        200,
        {"Content-Type": "application/json"},
        JSON.stringify(commentFixture)
      ]);
      
      store.commit();
      server.respond();

      call.get('comments').pushObject(comment);
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/phone_calls/55/comments');
      expect(call.getPath('comments.length')).toEqual(1);
    });

    it("adds to a Messages comment", function() {
      store.load(Radium.Message, {
          id: 55,
          contacts: [],
          comments: [],
          user: 468
        });

      var message = store.find(Radium.Message, 55);
      var user = store.find(Radium.User, 468);
      var comment = store.createRecord(Radium.Comment, {
        text: "This drug thing, this ain't police work.",
        user: 468
      });

      Radium.Comment.reopenClass({
        url: "messages/" + message.get('id') + "/comments"
      });


      server.respondWith(
        'POST', '/api/messages/55/comments', [
        200,
        {"Content-Type": "application/json"},
        JSON.stringify(commentFixture)
      ]);
      
      store.commit();
      server.respond();

      message.get('comments').pushObject(comment);
      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/messages/55/comments');
      expect(message.getPath('comments.length')).toEqual(1);
    });

    // Revisit, this will probably have to commit to the nested object
    xit("adds to a Activities comment", function() {
      store.load(Radium.Activity, {
          id: 55,
          comments: [],
          user: 468
        });

      var activity = store.find(Radium.Activity, 55);
      var user = store.find(Radium.User, 468);
      var comment = store.createRecord(Radium.Comment, {
        text: "This drug thing, this ain't police work.",
        user: 468
      });

      Radium.Comment.reopenClass({
        url: "todos/" + todo.get('id') + "/comments"
      });

      activity.get('comments').pushObject(comment);

      server.respondWith(
        'POST', '/api/activities/55/comments', [
        200,
        {"Content-Type": "application/json"},
        JSON.stringify(commentFixture)
      ]);
      
      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/api/activities/55/comments');
      expect(activity.getPath('comments.length')).toEqual(1);
    });


  });
});