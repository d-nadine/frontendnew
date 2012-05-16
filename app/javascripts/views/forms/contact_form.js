Radium.ContactForm = Radium.FormView.extend({
  templateName: 'contact_form',

  contactNameField: Ember.TextField.extend({
    attributeBindings: ['name'],
    name: 'contact-name',
    elementId: 'contact-name',
    classNames: ['span6'],
    focusOut: function(event) {
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

  submitForm: function() {
    var self = this;
    var emails = [],
        phoneNumbers = [],
        addresses = [],
        // Assigned User
        assignedTo = $('#assigned-to').val(),
        data = {
          createdAt: Ember.DateTime.create().toISO8601()
        };

    var emailFields = this.$('fieldset#email-addresses').find('.control-group'),
        phoneFields = this.$('fieldset#phone-numbers').find('.control-group'),
        addressFields = this.$('fieldset#addresses').find('.control-group');

    emailFields.each(function() {
      var emailGroup = {
        name: $(this).find('.email-name').val(),
        value: $(this).find('.email-value').val()
      };
      if (emailGroup.name && emailGroup.value) {
        emails.push(emailGroup);
      }
    });

    phoneFields.each(function() {
      var phoneGroup = {};
      phoneGroup.name = $(this).find('.phone-name').val();
      phoneGroup.value = $(this).find('.phone-value').val();
      if (phoneGroup.name && phoneGroup.value) {
        phoneNumbers.push(phoneGroup);
      }
    });

    addressFields.each(function() {
      var addressGroup = {};
      addressGroup.name = $(this).find('.address-name').val();
      addressGroup.street = $(this).find('.address-street').val();
      addressGroup.state = $(this).find('.address-state').val();
      addressGroup.country = $(this).find('.address-country').val();
      addressGroup.zip_code = $(this).find('.address-zip').val();
      if (addressGroup.name) {
        addresses.push(addressGroup);
      }
    });

    // Bundle up the values
    data.name = this.$('#contact-name').val();

    if (emails.length) {
      data.email_addresses_attributes = emails;
    }

    if (phoneNumbers.length) {
      data.phone_numbers_attributes = phoneNumbers;
    }

    if (addresses.length) {
      data.addresses_attributes = addresses;
    }

    if (this.checkForEmpty(data)) {
      this.error("Something was filled incorrectly, try again?");
      return false;
    }

    Radium.Contact.reopenClass({
      url: 'contacts',
      root: 'contact'
    });

    // Disable the form buttons
    this.hide();
    var contact = Radium.store.createRecord(Radium.Contact, data);
    Radium.store.commit();

    contact.addObserver('isValid', function() {
      if (this.get('isValid')) {
        self.success("Contact created");
      } else {
        self.fail();
      }
      Radium.Contact.reopenClass({
        url: null,
        root: null
      });
    });
    
    this.close();
  }
});
