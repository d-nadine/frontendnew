Radium.TodoForm = Radium.FormView.extend(Radium.FormReminder, {
  wantsReminder: false,
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  templateName: 'todo_form',

  submitForm: function() {
    var self = this;
    var contactIds = this.get('selectedContacts').getEach('id'),
        description = this.$('#description').val(),
        finishBy = this.$('#finish-by-date').val(),
        time = this.$('#finish-by-time').val(),
        user = this.$('select#assigned-to').val(),
        data = {
          todo: {
            description: description,
            finish_by: finishBy,
            user_id: user
          }
        };

    // Disable the form buttons
    this.sending();

    contactIds.forEach(function(id) {
      $.ajax({
        url: '/api/contacts/%@/todos'.fmt(id),
        type: 'POST',
        data: data,
        success: function(data) {
          self.success("Todo created");
        },
        error: function(jqXHR, textStatus, errorThrown) {
          self.error("Oops, %@.".fmt(jqXHR.responseText));
        }
      });
    });
  }
});