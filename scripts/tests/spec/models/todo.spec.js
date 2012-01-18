define('testdir/models/todo.spec', function(require) {
  
  var RadiumAdapter = require('adapter'),
      Radium = require('radium');
  
  var CREATE_FIXTURE = {
    id: 100,
    created_at: Ember.DateTime.create().toISO8601(),
    updated_at: Ember.DateTime.create().toISO8601(),
    kind: "general",
    description: "Finish programming radium",
    finish_by: "2012-12-22T15:06:27Z"
  };
  
  describe("Radium#Todo", function() {

    it("inherits from Radium.Core", function() {
      expect(Radium.Core.detect(Radium.Todo)).toBeTruthy();
    });


    describe("when a todo is overdue", function() {
      var adapter, store;

      it("marks the todo as overdue", function() {
        adapter = RadiumAdapter.create();
        store = DS.Store.create({adapter: adapter});

        store.loadMany(Radium.Todo, [{
            id: 1,
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
          }, {
            id: 2,
            created_at: "2011-12-15T15:07:13Z",
            updated_at: "2011-12-15T15:07:13Z",
            kind: "general",
            description: "Finish programming radium",
            finish_by: "2012-12-22T15:06:27Z",
            campaign: 3,
            call_list: 5,
            reference: null,
            contacts: [],
            comments: [],
            user: 468
          }
        ]);

        expect(store.find(Radium.Todo, 1).get('isOverdue')).toBeTruthy();
        expect(store.find(Radium.Todo, 2).get('isOverdue')).toBeFalsy();
      });
    });

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

      it("creates a new todo", function() {
        var todo, todoSpy;

        server.fakeHTTPMethods = true;
        server.respondWith(
          "POST", "/todos", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(CREATE_FIXTURE)
        ]);

        todo = store.createRecord(Radium.Todo, {
          kind: "general",
          description: "Finish programming radium",
          finish_by: "2011-12-22T15:06:27Z"
        });

        todoSpy = sinon.spy(todo, 'didCreate');

        store.commit();
        server.respond();

        expect(spy).toHaveBeenCalled();
        expect(todoSpy).toHaveBeenCalled();
        expect(todo.get('id')).toEqual(100);
      });

      // TODO: Implement this test when nested updates are working.
      xit("assigns a todo to a user", function() {
        var todo, user, todoSpy;

        server.fakeHTTPMethods = true;
        server.respondWith(
          "POST", "/todos/100", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(CREATE_FIXTURE)
        ]);

        store.load(Radium.Todo, CREATE_FIXTURE);
        store.load(Radium.User, {
          id: 50,
          name: "Jimmy McNulty",
          todos: []
        });

        todo = store.find(Radium.Todo, 100);
        user = store.find(Radium.User, 50);
        todoSpy = sinon.spy(todo, 'didUpdate');
        todo.set('user', user);

        store.commit();
        server.respond();

        expect(todoSpy).toHaveBeenCalled();
        expect(todo.get('user')).toEqual(user);
      });

      it("validates the kind property", function() {
        var todo;
        store.load(Radium.Todo, CREATE_FIXTURE);
        todo = store.find(Radium.Todo, 100);

        expect(todo.get('kind')).toBe('general');
        todo.set('kind', 'asdf');
        expect(todo.get('kind')).toEqual('pending')
      });
    });
  });
});