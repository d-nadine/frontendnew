Radium.TodoForm = Radium.FormView.extend({
  wantsReminder: false,
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  reminderForm: Ember.View.extend({
    id: 'add-reminder',
    templateName: 'reminder'
  }),
  reminderFormCache: null,
  addReminder: function() {
    // Cache the reminder form view so it can be destroyed and therefore
    // prevented from being submitted to the `submitForm` method
    var reminderForm = this.get('reminderFormCache') || this.reminderForm.create();
    this.set('reminderFormCache', reminderForm);
    if (this.get('wantsReminder')) {
      reminderForm.appendTo('#reminder-holder');
    } else {
      this.get('reminderFormCache').destroy();
      this.set('reminderFormCache', null);
    }
  }.observes('wantsReminder'),
  templateName: 'todo_form',

  submitForm: function() {
    var self = this;
    var contacts = this.get('selectedContacts').getEach('id'),
        description = this.$('#description').val(),
        finishBy = this.$('#finish-by-date').val(),
        time = this.$('#finish-by-time').val(),
        user = this.$('select#assigned-to').val(),
        data = {
          todo: {
            description: description,
            finish_by: finishBy,
            contacts: contacts,
            user_id: user
          }
        };

    // Disable the form buttons
    this.sending();

    $.ajax({
      url: '/api/todos',
      type: 'POST',
      data: data,
      success: function(data) {
        self.success("Todo created");
      },
      error: function(jqXHR, textStatus, errorThrown) {
        self.error("Oops, %@.".fmt(jqXHR.responseText));
      }
    })
  }
});