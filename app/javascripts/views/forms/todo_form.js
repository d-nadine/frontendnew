Radium.TodoForm = Radium.FormView.extend(Radium.FormReminder, {
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  templateName: 'todo_form',

  finishBy: Ember.computed(function(key, value) {
    var today = Ember.DateTime.create(),
        date = (value) ? Ember.DateTime.parse(value, '%Y-%m-%d') : today;

    if (date.get('hour') >= 17 && Ember.DateTime.compareDate(date, today) === 0) {
      date = date.advance({day: 1});
    }

    return date;
  }).property().cacheable(),

  headerContext: function() {
    var params = this.get('params'),
        currentYear = Radium.appController.getPath('today.year'),
        date = this.get('finishBy'),
        sameYearString = '%A, %e/%D',
        differentYearString = '%A, %e/%D/%Y',
        format = (date.get('year') !== currentYear) ? differentYearString : sameYearString,
        dateString = date.toFormattedString(format);

    if (params.type === 'contacts') {
      var name = params.target.name || params.target.get('name');
      return "Assign a Todo to %@ for %@".fmt(name, dateString);
    } else {
      return "Add a Todo for %@".fmt(dateString);
    }
    
  }.property('finishBy').cacheable(),

  description: Ember.TextArea.extend(Ember.TargetActionSupport, {
    elementId: 'description',
    attributeBindings: ['name'],
    placeholderBinding: 'parentView.headerContext',
    name: 'description',
    classNames: ['span8'],
    action: 'submitForm',
    target: 'parentView',
    didInsertElement: function() {
      this.$().autosize().css('resize','none');
    },
    keyUp: function() {
      if (this.$().val() !== '') {
        this.setPath('parentView.isValid', true);
        this.setPath('parentView.isError', false);
        this.$().parent().removeClass('error');
      } else {
        this.setPath('parentView.isValid', false);
      }
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
    var self = this;
    var targetId = this.getPath('params.target.id'),
        targetType = this.getPath('params.type'),
        contactIds = this.get('selectedContacts').getEach('id'),
        description = this.$('#description').val(),
        finishByValue = this.get('finishBy').adjust({
                          hour: 17, 
                          minute: 0, 
                          second: 0
                        }),
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
        },
        selectedContacts = this.getPath('params.target'),
        isBulk = (Ember.typeOf(selectedContacts) === 'array') ? true : false;

    if (this.checkForEmpty(data)) {
      this.error("Something was filled incorrectly, try again?");
      return false;
    }
    
    // set the url based on the context, ie. a contact or meeting todo versus
    // general todo that is created for the logged in user.
    if (targetType) {
      Radium.Todo.reopenClass({
        url: '%@/%@/todos'.fmt(targetType, targetId),
        root: 'todo'
      });
    } else {
      Radium.Todo.reopenClass({
        url: 'todos',
        root: 'todo'
      });
    }
    
    // Disable the form buttons
    this.hide();

    var todo = Radium.store.createRecord(Radium.Todo, data);
    Radium.store.commit();

    todo.addObserver('isValid', function() {
      if (this.get('isValid')) {
        Radium.Todo.reopenClass({
          url: null,
          root: null
        });
        self.success("Todo created");
      } else {
        self.fail();
      }
    });

    todo.addObserver('isError', function() {
      self.fail();
    });

    Radium.FormManager.send('closeForm');
  }
});