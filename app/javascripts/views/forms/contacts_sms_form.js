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
        },
        settings = {
          url: '/api/sms',
          type: 'POST',
          data: data
        },
        request = jQuery.extend(settings, CONFIG.ajax);

    // Disable the form buttons
    this.sending();

    $.ajax(request)
      .success(function() {
        self.success("SMS sent");
      })
      .error(function(jqXHR, textStatus, errorThrown) {
        self.error("Oops, %@.".fmt(jqXHR.responseText));
      });
  }
});