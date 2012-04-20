Radium.TodoForm = Radium.FormView.extend(Radium.FormReminder, {
  wantsReminder: false,
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  templateName: 'todo_form',

  findContactsField: Radium.AutocompleteTextField.extend({
    sourceBinding: 'Radium.contactsController.contactNamesWithObject',
    select: function(event, ui) {
      var contact = ui.item.contact;
      contact.set('isSelected', true);
      this.set('value', null);
      event.preventDefault();
    }
  }),

  // Form actions
  didCreateTodo: function(data) {
    Radium.store.load(Radium.Todo, data);
    self.success("Todo created");
  },

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
      .success(self.didCreateTodo)
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
          .success(self.didCreateTodo)
          .error(self.errorMessage);
      });
    }
  }
});