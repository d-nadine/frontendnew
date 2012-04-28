Radium.GroupForm = Radium.FormView.extend({
  templateName: 'group_form',

  groupNameField: Ember.TextField.extend({
    attributeBindings: ['name'],
    name: 'group-name',
    elementId: 'group-name',
    classNames: ['span6'],
    keyUp: function() {
      if (this.$().val() !== '') {
        this.setPath('parentView.isValid', true);
        this.setPath('parentView.isError', false);
        this.$().parent().removeClass('error');
      }
    },
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
    var name = this.$('input#group-name').val(),
        data = {
          name: name
        };

    // Disable the form buttons
    this.sending();

    var contact = Radium.store.createRecord(Radium.Group, data);
    Radium.store.commit();

    contact.addObserver('isValid', function() {
      if (this.get('isValid')) {
        self.success("Group created");
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

    contact.addObserver('isError', function() {
      if (this.get('isError')) {
        self.error("Look like something broke. Report it so we can fix it");
      }
    });

  }
});