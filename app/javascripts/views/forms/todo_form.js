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
        sameYearString = '%A, %e/%D',
        differentYearString = '%A, %e/%D/%Y',
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

  submitForm: function() {
    var self = this;
    var targetId = this.getPath('params.target.id'),
        targetType = this.getPath('params.type'),
        contactIds = this.get('selectedContacts').getEach('id'),
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
    this.sending();

    var todo = Radium.store.createRecord(Radium.Todo, data);
    Radium.todosController.add(todo);
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
  }
});