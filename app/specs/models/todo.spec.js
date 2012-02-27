describe("Radium#Todo", function() {
    var CREATE_FIXTURE = {
      id: 100,
      created_at: Ember.DateTime.create().toISO8601(),
      updated_at: Ember.DateTime.create().toISO8601(),
      kind: "general",
      finished: false,
      description: "Finish programming radium",
      finish_by: "2012-12-22T15:06:27Z"
    };


  it("inherits from Radium.Core", function() {
    expect(Radium.Core.detect(Radium.Todo)).toBeTruthy();
  });
  
  describe("when a todo is overdue", function() {
    var adapter, store;

    it("marks the todo as overdue", function() {
      adapter = RadiumAdapter.create();
      store = DS.Store.create({revision: 1,adapter: adapter});

      store.loadMany(Radium.Todo, [{
          id: 1,
          created_at: "2011-12-15T15:07:13Z",
          updated_at: "2011-12-15T15:07:13Z",
          kind: "general",
          description: "Finish programming radium",
          finish_by: "2011-12-22T15:06:27Z",
          finished: false,
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
          finished: false,
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

    it("creates a new todo", function() {
      var todo, todoSpy;

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/api/todos", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify(CREATE_FIXTURE)
      ]);

      todo = store.createRecord(Radium.Todo, {
        kind: "general",
        description: "Finish programming radium",
        finishBy: "2011-12-22T15:06:27Z"
      });

      todoSpy = sinon.spy(todo, 'didCreate');

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(todoSpy).toHaveBeenCalled();
      expect(todo.get('id')).toEqual(100);
    });

    it("completes a todo", function() {
      store.load(Radium.Todo, CREATE_FIXTURE);
      var todo = store.find(Radium.Todo, 100);

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/api/todos", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify(jQuery.extend(CREATE_FIXTURE, {finished: true}))
      ]);

      todo.set('finished', true);
      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(todo.get('finished')).toBeTruthy();
    });

    // TODO: Implement this test when nested updates are working.
    it("assigns a new todo to a user", function() {
      var todo, user, todoSpy;

      server.fakeHTTPMethods = true;
      server.respondWith(
        "POST", "/api/todos", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify(jQuery.extend(CREATE_FIXTURE, {user: 50}))
      ]);

      store.load(Radium.User, {
        id: 50,
        name: "Jimmy McNulty",
        todos: []
      });

      todo = store.createRecord(Radium.Todo, CREATE_FIXTURE);
      user = store.find(Radium.User, 50);

      // TODO: This needs to be implemented by Ember-Data 
      todo.set('user', user);
      user.get('todos').pushObject(todo);

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(todo.get('user')).toEqual(user);
      expect(user.getPath('todos.length')).toEqual(1);
    });

    it("validates the kind property", function() {
      var todo;
      store.load(Radium.Todo, CREATE_FIXTURE);
      todo = store.find(Radium.Todo, 100);

      expect(todo.get('kind')).toBe('general');
      todo.set('kind', 'asdf');
      expect(todo.get('kind')).toEqual('pending')
    });

    xit("creates a Contacts todo", function() {
      var todo, user,
          contactFixture = {
            id: 50,
            name: "Jimmy McNulty",
            todos: []
          };

      server.respondWith(
        "POST", "/contacts/50/todos", [
        200, 
        {"Content-Type": "application/json"},
        JSON.stringify(
          jQuery.extend(
            CREATE_FIXTURE, 
            {
              contacts: [50],
              reference: jQuery.extend(contactFixture, {todos: [100]})
            }
          )
        )
      ]);

      store.load(Radium.Contact, contactFixture);

      contact = store.find(Radium.Contact, 50);

      todo = store.createRecord(Radium.Todo, jQuery.extend(
        CREATE_FIXTURE, {
          _type: 'contact',
          relation: contact.get('id'),
        })
      );

      store.commit();
      server.respond();

      expect(spy).toHaveBeenCalled();
      expect(spy.getCall(0).args[0].url).toBe('/contacts/50/todos');
      expect(contact.getPath('todos.length')).toEqual(1);
      expect(contact.get('todos').objectAt(0).get('id')).toEqual(50)
    });
    
  });
});