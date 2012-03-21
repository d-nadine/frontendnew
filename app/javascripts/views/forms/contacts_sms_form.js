Radium.ContactSMSForm = Radium.FormView.extend({
  templateName: 'contacts_sms_form',
  phoneNumbersBinding: 'Radium.contactsController.selectedContactsPhoneNumbers',
  submitForm: function() {
    var self = this;
    var phoneNumbers = this.get('phoneNumbers'),
        message = this.$('#message').val(),
        data = {
          sms: {
            to: phoneNumbers,
            message: message
          }
        };

    // Disable the form buttons
    this.sending();

    $.ajax({
      url: '/api/sms',
      type: 'POST',
      data: data,
      success: function() {
        self.success("SMS sent");
      },
      error: function(jqXHR, textStatus, errorThrown) {
        self.error("Oops, %@.".fmt(jqXHR.responseText));
      }
    })
  }
});