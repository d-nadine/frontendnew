Radium.TodoForm = Radium.FormView.extend(Radium.FormReminder, {
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  templateName: 'todo_form',

  // finishByBinding: 'Radium.todosFormController.finishBy',
  finishBy: Ember.DateTime.create({hour: 17, minute: 0}),

  headerDate: function() {
    var currentYear = Radium.appController.getPath('today.year'),
        date = this.get('finishBy'),
        sameYearString = '%A, %m/%D @ %i:%M%p',
        differentYearString = '%A, %m/%D/%Y @ %i:%M%p',
        format = (date.get('year') !== currentYear) ? differentYearString : sameYearString;
    return date.toFormattedString(format);
  }.property('finishBy'),

  description: Ember.TextArea.extend({
    elementId: 'description',
    attributeBindings: ['name'],
    name: 'description',
    classNames: ['span8'],
    focusOut: function() {
      if (this.$().val() !== '') {
        this.setPath('parentView.isValid', true);
        this.$().parent().removeClass('error');
        this.$().next('span.help-inline').remove();
      } else {
        this.$().parent().addClass('error');
        this.setPath('parentView.isValid', false);
        this.$().after('<span class="help-inline">Can\'t create an empty todo.</span>');
      }
    }
  }),

  finishByDateField: Radium.DatePickerField.extend({
     elementId: 'finish-by-date',
     name: 'finish-by-date',
     classNames: ['input-small'],
     minDate: new Date(),
     valueBinding: Ember.Binding.transform({
      to: function(value, binding) {
        return value.toFormattedString('%Y-%m-%d');
      },
      from: function(value, binding) {
        var date = binding.getPath('parentView.finishBy'),
            dateValues = value.split('-');
        
        return date.adjust({
          year: parseInt(dateValues[0]),
          month: parseInt(dateValues[1]),
          day: parseInt(dateValues[2])
        });
      }
    }).from('parentView.finishBy')
  }),

  findContactsField: Radium.AutocompleteTextField.extend({
    sourceBinding: 'Radium.contactsController.contactNamesWithObject',
    select: function(event, ui) {
      event.preventDefault();
      event.stopImmediatePropagation();
      console.log('select', event);
      var contact = ui.item.contact;
      contact.set('isSelected', true);
      this.set('value', null);
    }
  }),
  
  errorMessage: function(jqXHR, textStatus, errorThrown) {
    self.error("Oops, %@.".fmt(jqXHR.responseText));
  },

  close: function() {
    Radium.contactsController.setEach('isSelected', false);
    this._super();
  },

  submitForm: function() {
    var self = this;
    var contactIds = this.get('selectedContacts').getEach('id'),
        description = this.$('#description').val(),
        finishByDate = this.$('#finish-by-date').val(),
        finishByTime = this.$('#finish-by-time').val(),
        finishByMeridian = this.$('#finish-by-meridian').val(),
        finishByValue = this.timeFormatter(finishByDate, finishByTime, finishByMeridian),
        userId = this.$('select#assigned-to').val(),
        data = {
          todo: {
            description: description,
            finish_by: finishByValue,
            user_id: userId
          }
        };

    // Disable the form buttons
    this.sending();
    
    var userSettings = {
          url: '/api/todos'.fmt(userId),
          type: 'POST',
          data: JSON.stringify(data)
        },
        userRequest = jQuery.extend(userSettings, CONFIG.ajax);

    $.ajax(userRequest)
      .success(function(data) {
        Radium.store.load(Radium.Todo, data);
        self.success("Todo created");
      })
      .error(function(jqXHR, textStatus, errorThrown) {
        self.error("Oops, %@.".fmt(jqXHR.responseText));
      });

    if (contactIds.length) {
      contactIds.forEach(function(id) {
        var settings = {
              url: '/api/contacts/%@/todos'.fmt(id),
              type: 'POST',
              data: JSON.stringify(data)
            },
            request = jQuery.extend(settings, CONFIG.ajax);

        $.ajax(request)
          .success(function(data) {
            Radium.store.load(Radium.Todo, data);
            self.success("Todo created");
          })
          .error(function(jqXHR, textStatus, errorThrown) {
            self.error("Oops, %@.".fmt(jqXHR.responseText));
          });
      });
    }
  }
});