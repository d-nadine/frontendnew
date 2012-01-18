define('testdir/models/comment.spec', function() {

  var RadiumAdapter = require('adapter'),
      Radium = require('radium');


  describe("Radium#Comment", function() {
    
    describe("when adding a comment", function() {
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

      it("adds to a todo", function() {
        var commentFixture = {
              id: 7,
              created_at: "2011-12-14T13:25:36Z",
              updated_at: "2011-12-14T13:25:36Z",
              text: "Text 2",
              user: 468,
              attachments: []
            };

        var todo = store.load(Radium.Todo, {
            id: 55,
            created_at: "2011-12-15T15:07:13Z",
            updated_at: "2011-12-15T15:07:13Z",
            kind: "general",
            description: "Finish programming radium",
            finish_by: "2011-12-22T15:06:27Z",
            campaign: 3,
            call_list: 5,
            reference: null,
            contacts: [],
            comments: [],
            user: 468
          })

        var user = store.load(Radium.User, {
          id: 468,
          name: "Bunny Colvin"
        });

        var comment = store.createRecord(Radium.Comment, {
          text: "This drug thing, this ain't police work.",
          user: 468
        });

        server.respondWith(
          'POST', '/todos/55/comments', [
          200,
          {"Content-Type": "application/json"},
          JSON.stringify(commentFixture)
        ]);
        
        store.commit();
        server.respond();
console.log(spy.getCall(0).args[0].url)
        expect(spy).toHaveBeenCalled();
        expect(spy.getCall(0).args[0].url).toBe('/todos/55/comments');
      });
    });
  });
});