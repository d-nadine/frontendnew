Radium.GroupForm = Radium.FormView.extend({
  templateName: 'group_form',
  groupNameField: Ember.TextField.extend(Radium.UniqueTextFieldValidation, {
    attributeBindings: ['name'],
    name: 'group-name',
    elementId: 'group-name',
    classNames: ['span6'],
    storedNamesBinding: 'Radium.groupsController.names'
  }),

  submitForm: function() {
    var self = this;
    var name = this.$('input#group-name').val(),
        data = {
          name: name
        };

    if (this.checkForEmpty(data)) {
      this.error("Something was filled incorrectly, try again?");
      return false;
    }
    // Disable the form buttons
    this.hide();

    var contact = Radium.store.createRecord(Radium.Group, data);
    Radium.store.commit();

    contact.addObserver('isValid', function() {
      if (this.get('isValid')) {
        self.success("Group created");
      } else {
        self.fail();
      }
    });

    this.close();
    
  }
});