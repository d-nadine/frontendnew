Radium.ContactForm = Radium.FormView.extend({
  templateName: 'contact_form',
  submitForm: function() {
    var self = this;
    var emails = [],
        phoneNumbers = [],
        addresses = [],
        // Assigned User
        assignedTo = $('#assigned-to').val(),
        data = {};

    var emailFields = this.$('fieldset#email-addresses').find('.control-group'),
        phoneFields = this.$('fieldset#phone-numbers').find('.control-group'),
        addressFields = this.$('fieldset#addresses').find('.control-group');

    emailFields.each(function() {
      var emailGroup = {
        name: $(this).find('.email-name').val(),
        value: $(this).find('.email-value').val()
      };
      emails.push(emailGroup);
    });

    phoneFields.each(function() {
      var phoneGroup = {};
      phoneGroup.name = $(this).find('.phone-name').val();
      phoneGroup.value = $(this).find('.phone-value').val();
      phoneNumbers.push(phoneGroup);
    });

    addressFields.each(function() {
      var addressGroup = {};
      addressGroup.name = $(this).find('.address-name').val();
      addressGroup.street = $(this).find('.address-street').val();
      addressGroup.state = $(this).find('.address-state').val();
      addressGroup.country = $(this).find('.address-country').val();
      addressGroup.zip_code = $(this).find('.address-zip').val();
      addressFields.push(addressGroup);
    });

    // Bundle up the values
    data = {
      contact: {
        name: this.$('#contact-name').val(),
        email_addresses_attributes: emails,
        phone_numbers_attributes: phoneNumbers,
        addresses_attributes: addresses
      }
    }

    // Disable the form buttons
    this.sending();

    var settings = {
          url: '/api/contacts',
          data: data,
          type: 'POST'
        },
        request = jQuery.extend(settings, CONFIG.ajax);

    $.ajax(request)
      .success(function(data) {
        Radium.store.load(Radium.Contact, data);
        self.success("Contact created");
      })
      .error(function(jqXHR, textStatus, errorThrown) {
        self.error("Oops, %@.".fmt(jqXHR.responseText));
      });

  }
});