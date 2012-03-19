Radium.ContactsMessageForm = Radium.FormView.extend({
  templateName: 'contacts_message_form',
  emailsBinding: 'Radium.contactsController.selectedContactsEmails',
  submitForm: function() {
    var self = this;
    var emails = this.get('emails'),
        subject = this.$('input#subject').val(),
        message = this.$('input#message').val(),
        data = {
          email: {
            to: emails,
            subject: subject,
            message: message
          }
        };

    // Disable the form buttons
    this.sending();

    $.ajax({
      url: '/api/emails',
      type: 'POST',
      data: data,
      success: function() {
        self.success("Message sent");
      },
      error: function(jqXHR, textStatus, errorThrown) {
        self.error("Oops, %@.".fmt(jqXHR.responseText));
      }
    })
  }
});