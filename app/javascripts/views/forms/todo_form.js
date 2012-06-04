Radium.TodoForm = Radium.FormView.extend(Radium.FormReminder, {
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  templateName: 'todo_form',

  isBulk: function() {
    return Ember.typeOf(this.get('selection')) === 'array';
  }.property('selection'),

  finishBy: Ember.computed(function(key, value) {
    var today = Ember.DateTime.create(),
        date = (value) ? Ember.DateTime.parse(value, '%Y-%m-%d') : today;

    if (date.get('hour') >= 17 && Ember.DateTime.compareDate(date, today) === 0) {
      date = date.advance({day: 1});
    }

    return date;
  }).property().cacheable(),

  headerContext: function() {
    var selection = this.get('selection'),
        currentYear = Radium.appController.getPath('today.year'),
        date = this.get('finishBy'),
        sameYearString = '%A, %e/%D',
        differentYearString = '%A, %e/%D/%Y',
        format = (date.get('year') !== currentYear) ? differentYearString : sameYearString,
        dateString = date.toFormattedString(format);

    if (Ember.typeOf(selection) === 'array' && selection.get('length') > 1) {
      var totalTodoContacts = selection.get('length');
      return "Assign a Todo to %@ contacts for %@".fmt(totalTodoContacts, dateString);
    } else {
      if (selection) {
        var name = selection.getPath('firstObject.name') || selection.get('name');
        return "Assign a Todo to %@ for %@".fmt(name, dateString);
      } else {
        return "Add a Todo for %@".fmt(dateString);
      }
    }
    
  }.property('finishBy', 'selection').cacheable(),

  description: Ember.TextArea.extend(Ember.TargetActionSupport, {
    elementId: 'description',
    viewName: 'description',
    attributeBindings: ['name'],
    placeholderBinding: 'parentView.headerContext',
    name: 'description',
    classNames: ['span8'],
    action: 'submitForm',
    target: 'parentView',
    didInsertElement: function() {
      this.$().autosize().css('resize','none');
    },
    keyUp: function(event) {
      if (this.$().val() !== '') {
        this.setPath('parentView.isValid', true);
        this.setPath('parentView.isError', false);
        this.$().parent().removeClass('error');
      } else {
        this.setPath('parentView.isValid', false);
      }
      this._super(event);
    },
    keyPress: function(event) {
      if (event.keyCode === 13 && !event.ctrlKey) {
        event.preventDefault();
        if (this.$().val() !== '') {
          this.triggerAction();
        }
      }
    },
    focusOut: function() {
      if (this.$().val() !== '') {
        this.setPath('parentView.isValid', true);
        // this.setPath('parentView.isError', false);
        // this.$().parent().removeClass('error');
      } else {
        // this.$().parent().addClass('error');
        // this.setPath('parentView.isError', true);
        this.setPath('parentView.isValid', false);
      }
    }
  }),

  assignedUser: null,

  assignToSelect: Ember.Select.extend({
    elementId: 'assigned-to',
    contentBinding: 'Radium.usersController',
    optionLabelPath: 'content.abbrName',
    optionValuePath: 'content.id',
    didInsertElement: function() {
      var user = this.get('content').filterProperty('isLoggedIn', true)[0];
      this.setPath('parentView.assignedUser', user);
      this.set('selection', user);
    },
    change: function() {
      this._super();
      this.setPath('parentView.assignedUser', this.get('selection'));
    }
  }),  

  finishByDateField: Radium.DatePickerField.extend({
    elementId: 'finish-by-date',
    name: 'finish-by-date',
    classNames: ['input-small'],
    minDate: function() {
      var now = Ember.DateTime.create();
      return (now.get('hour') >= 17) ? '+1d' : new Date();
    }.property().cacheable(),
    valueBinding: Ember.Binding.dateTime('%Y-%m-%d')
                  .from('parentView.finishBy')
  }),

  submitForm: function() {
    if (this.checkForEmpty(data)) {
      this.error("Something was filled incorrectly, try again?");
      return false;
    }

    // User enteries
    var selectedContacts,
        selection = this.get('selection'),
        description = this.getPath('description.value'),
        finishByValue = this.get('finishBy').adjust({hour: 17, minute: 0, second: 0}),
        assignedUser = this.get('assignedUser'),
        assignedUserId = assignedUser.get('id'),
        data = {
          description: description,
          finishBy: finishByValue,
          finished: false,
          user_id: assignedUserId,
          user: assignedUser,
          created_at: Ember.DateTime.create(),
          hasAnimation: true
        };

    // Determine that if there are selected items, the todo is contact based


    if (selection) {
      if (this.get('isBulk')) {
        // Until bulk commits are enabled, multiple POSTs must be made
    
        selection.forEach(function(model) {
          // Determine the selection's type, id
          var root = Radium.store.adapter.rootForType(model.constructor),
              plural = Radium.store.adapter.pluralize(root),
              id = model.get('id');

          Radium.Todo.reopenClass({
            url: '%@/%@/todos'.fmt(plural, id),
            root: 'todo'
          });

          var bulkTodo = Radium.store.createRecord(Radium.Todo, data);
          Radium.store.commit();
        });
      } else {
        var root = Radium.store.adapter.rootForType(selection.constructor),
            plural = Radium.store.adapter.pluralize(root),
            id = selection.get('id');

        Radium.Todo.reopenClass({
          url: '%@/%@/todos'.fmt(plural, id),
          root: 'todo'
        });

        var singleTodo = Radium.store.createRecord(Radium.Todo, data);
      }
    } else {
      Radium.Todo.reopenClass({
        url: 'todos',
        root: 'todo'
      });
      var todo = Radium.store.createRecord(Radium.Todo, data);
    }

    Radium.store.commit();

    Radium.Todo.reopenClass({
      url: null,
      root: null
    });

    this.get('parentView').close();
  }

  // submitForm: function() {
  //   debugger;
  //   var self = this;
  //   var targetId = this.getPath('context.target.id'),
  //       targetType = this.getPath('context.type'),
  //       contactIds = this.get('selectedContacts').getEach('id'),
  //       description = this.$('#description').val(),
  //       finishByValue = this.get('finishBy').adjust({
  //                         hour: 17, 
  //                         minute: 0, 
  //                         second: 0
  //                       }),
  //       assignedUser = this.get('assignedUser'),
  //       assignedUserId = assignedUser.get('id'),
  //       data = {
  //         description: description,
  //         finishBy: finishByValue,
  //         finished: false,
  //         user_id: assignedUserId,
  //         user: assignedUser,
  //         created_at: Ember.DateTime.create(),
  //         hasAnimation: true
  //       },
  //       selectedContacts = this.getPath('context.target'),
  //       isBulk = this.get('isBulk');

  //   if (this.checkForEmpty(data)) {
  //     this.error("Something was filled incorrectly, try again?");
  //     return false;
  //   }
    
  //   // set the url based on the context, ie. a contact or meeting todo versus
  //   // general todo that is created for the logged in user.
  //   if (targetType) {
  //     Radium.Todo.reopenClass({
  //       url: '%@/%@/todos'.fmt(targetType, targetId),
  //       root: 'todo'
  //     });
  //   } else {
  //     Radium.Todo.reopenClass({
  //       url: 'todos',
  //       root: 'todo'
  //     });
  //   }
    
  //   // Disable the form buttons
  //   this.hide();

  //   var todo = Radium.store.createRecord(Radium.Todo, data);
  //   Radium.store.commit();

  //   todo.addObserver('isValid', function() {
  //     if (this.get('isValid')) {
  //       Radium.Todo.reopenClass({
  //         url: null,
  //         root: null
  //       });
  //       self.success("Todo created");
  //     } else {
  //       self.fail();
  //     }
  //   });

  //   todo.addObserver('isError', function() {
  //     self.fail();
  //   });

  //   this.get('parentView').close();
  // }
});