Radium.CompanyForm = Radium.FormView.extend({
  templateName: 'company_form',

  companyNameField: Ember.TextField.extend(Radium.UniqueTextFieldValidation, {
    attributeBindings: ['name'],
    name: 'contact-name',
    elementId: 'contact-name',
    classNames: ['span6'],
    storedNamesBinding: 'Radium.contactsController.names'
  }),

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
        addressFields = this.$('fieldset#addresses').find('.control-group'),
        website = this.$('input#website').val();

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
        addressFields.push(addressGroup);
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

    if (website) {
      data.fields_attributes = [{
        name: 'Website',
        value: website,
        kind: 'url'
      }];
    }

    if (this.checkForEmpty(data)) {
      this.error("Something was filled incorrectly, try again?");
      return false;
    }

    // Disable the form buttons
    this.sending();

    var company = Radium.store.createRecord(Radium.Contact, data);
    Radium.store.commit();

    company.addObserver('isValid', function() {
      if (this.get('isValid')) {
        self.success("Company created");
      } else {
        self.error("Something was filled incorrectly, try again?");
      }
    });

    company.addObserver('isError', function() {
      if (this.get('isError')) {
        self.error("Look like something broke. Report it so we can fix it");
      }
    });

  }
});