Radium.TodoForm = Radium.FormView.extend(Radium.FormReminder, {
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  templateName: 'todo_form',

  // finishByBinding: 'Radium.todosFormController.finishBy',
  finishBy: function() {
    var now = Ember.DateTime.create();

    if (now.get('hour') >= 17) {
      return now.advance({day: 1, hour: 17, minute: 0});
    } else {
      return now.adjust({hour: 17, minute: 0})
    }
  }.property().cacheable(),

  headerDate: function() {
    var currentYear = Radium.appController.getPath('today.year'),
        date = this.get('finishBy'),
        sameYearString = '%A, %m/%D',
        differentYearString = '%A, %m/%D/%Y',
        format = (date.get('year') !== currentYear) ? differentYearString : sameYearString;
    return date.toFormattedString(format);
  }.property('finishBy'),

  description: Ember.TextArea.extend(Ember.TargetActionSupport, {
    elementId: 'description',
    attributeBindings: ['name'],
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
        this.setPath('parentView.isError', false);
        this.$().parent().removeClass('error');
      } else {
        this.$().parent().addClass('error');
        this.setPath('parentView.isError', true);
        this.setPath('parentView.isValid', false);
      }
    }
  }),

  assignToSelect: Ember.Select.extend({
    elementId: 'assigned-to',
    contentBinding: 'Radium.usersController',
    optionLabelPath: 'content.abbrName',
    optionValuePath: 'content.id',
    didInsertElement: function() {
      var user = this.get('content').filterProperty('isLoggedIn', true)[0];
      this.set('selection', user);
    }
  }),  

  finishByDateField: Radium.DatePickerField.extend({
    elementId: 'finish-by-date',
    name: 'finish-by-date',
    classNames: ['input-small'],
    valueBinding: Ember.Binding.transform({
      to: function(value, binding) {
        return value.toFormattedString('%Y-%m-%d');
      },
      from: function(value, binding) {
        var dateValues,
            date = binding.getPath('parentView.finishBy');
        
        if (value) {
          dateValues = value.split('-');
        } else {
          dateValues = binding.get('_cachedDate').split('-');
        }
        
        return date.adjust({
          year: parseInt(dateValues[0]),
          month: parseInt(dateValues[1]),
          day: parseInt(dateValues[2])
        });
      }
    }).from('parentView.finishBy')
  }),

  close: function() {
    Radium.contactsController.setEach('isSelected', false);
    this._super();
  },

  submitForm: function() {
    var self = this;
    var contactIds = this.get('selectedContacts').getEach('id'),
        description = this.$('#description').val(),
        finishByDate = this.$('#finish-by-date').val(),
        finishByParsed = Ember.DateTime.parse(finishByDate, '%Y-%m-%D'),
        finishByValue = Ember.DateTime.create(finishByParsed),
        userId = this.$('select#assigned-to').val(),
        data = {
          description: description,
          finishBy: finishByValue.toISO8601(),
          user_id: userId,
          created_at: Ember.DateTime.create().toISO8601()
        };

    if (!userId) {
      this.error("A user must be assigned to a todo.");
      return false;
    }
    // Disable the form buttons
    this.sending();

    Radium.Todo.reopenClass({
      url: 'todos',
      root: 'todo'
    });

    var todo = Radium.store.createRecord(Radium.Todo, data);
    Radium.todosController.add(todo);
    Radium.store.commit();

    todo.addObserver('isValid', function() {
      if (this.get('isValid')) {
        Radium.Todo.reopenClass({
          url: null
        });
        self.success("Todo created");
      } else {
        // Anticipating more codes as the app grows.
        switch (this.getPath('errors.status')) {
          case 422:
            self.error("Something was filled incorrectly, try again?");
            break;
          default:
            self.error("Look like something broke. Report it so we can fix it");
            break;
        }
        
      }
    });

    todo.addObserver('isError', function() {
      if (this.get('isError')) {
        self.error("Look like something broke. Report it so we can fix it");
      }
    });
  }
});