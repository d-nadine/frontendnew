Radium.CompanyForm = Radium.FormView.extend({
  templateName: 'company_form',

  companyNameField: Ember.TextField.extend({
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

    // Disable the form buttons
    this.sending();

    var company = Radium.store.createRecord(Radium.Contact, data);
    Radium.store.commit();

    company.addObserver('isValid', function() {
      if (this.get('isValid')) {
        self.success("Company created");
      } else {
        // Anticipating more codes as the app grows.
        switch (this.getPath('errors.status')) {
          case 422:
            self.error("Something was filled incorrectly, try again?");
            break;
          default:
            self.error("Look like something broke. Report it so we can fix it");
            break;
        }
        
      }
    });

    company.addObserver('isError', function() {
      if (this.get('isError')) {
        self.error("Look like something broke. Report it so we can fix it");
      }
    });

  }
});