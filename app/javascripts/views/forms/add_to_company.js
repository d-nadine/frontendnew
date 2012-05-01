Radium.AddToCompanyForm = Radium.FormView.extend({
  templateName: 'add_to_company',
  newCompanyName: '',
  selectedCompany: null,
  companySearchField: Radium.AutocompleteTextField.extend({
    attributeBindings: ['name'],
    name: 'contact-name',
    elementId: 'contact-name',
    classNames: ['span6'],
    sourceBinding: 'Radium.groupsController.companiesWithObject',
    newCompanyNameBinding: 'parentView.newCompanyName',
    select: function(event, ui) {
      if ( ui.item ) {
        event.target.value = '';
        this.resetNewCompanyName();
        event.preventDefault();
      }
      this.$().val(ui.item.label);
      this.setPath('parentView.selectedCompany', ui.item.group);
      this.testCompanyName();
    },

    keyUp: function() {
      if (this.$().val() === '') {
        this.setPath('parentView.isValid', false);
        this.setPath('parentView.isError', true);
        this.setPath('parentView.isEmptyError', true);
        this.setPath('parentView.selectedCompany', null);
        this.resetNewCompanyName();
      }
    },

    focusOut: function() {
      if (this.$().val() === '') {
        this.setPath('parentView.isValid', false);
        this.setPath('parentView.isError', true);
        this.setPath('parentView.isEmptyError', true);
        this.resetNewCompanyName();
      } else {
        this.setPath('parentView.isValid', true);
        this.setPath('parentView.isError', false);
        this.setPath('parentView.isEmptyError', false);
        this.testCompanyName();
      }
    },

    resetNewCompanyName: function() {
      this.set('newCompanyName', null);
      this.setPath('parentView.willCreateNewCompany', false);
      this.setPath('parentView.selectedCompany', null);
    },

    testCompanyName: function() {
      var companies = this.get('source').getEach('label'),
          value = this.$().val();

      if (companies.indexOf(value) < 0) {
        this.resetNewCompanyName();
        this.setPath('parentView.willCreateNewCompany', true);
        this.set('newCompanyName', value);
      } else {
        this.setPath('parentView.isValid', true);
        this.setPath('parentView.isError', false);
        this.setPath('parentView.isEmptyError', false);
      }
    }
  }),
  submitForm: function() {
    var self = this,
        selectedCompany = this.get('selectedCompany'),
        newCompanyName = this.get('newCompanyName'),
        selectedContact = Radium.selectedContactController.get('content');

    this.sending();
    if (selectedCompany) {
      selectedCompany.get('contacts').pushObject(selectedContact);
      selectedContact.get('groups').pushObject(selectedCompany);
      debugger;
      Radium.store.commit();
    } else {
      var newGroup = Radium.store.createRecord(Radium.Group, {
        name: newCompanyName,
        contact_ids: [selectedContact.get('id')]
      });

      Radium.store.commit();
      newGroup.addObserver('isValid', function() {
        if (this.get('isValid')) {
          self.success("New group created");
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

      newGroup.addObserver('isError', function() {
        if (this.get('isError')) {
          self.error("Look like something broke. Report it so we can fix it");
        }
      });
    }

    return false;
  }
});