Radium.MessageForm = Radium.FormView.extend({
  templateName: 'message_form',

  ccEmailValues: Ember.ArrayController.create({
    contentBinding: 'Radium.everyoneController.emails',
    selected: Ember.A([])
  }),

  bccEmailValues: Ember.ArrayController.create({
    contentBinding: 'Radium.everyoneController.emails',
    selected: Ember.A([])
  }),

  // TODO: Move 'isValid' prop into other forms once validation kinks worked out.
  isValid: function() {
    return (this.getPath('invalidFields.length')) ? false : true;
  }.property('invalidFields.@each').cacheable(),
  
  subjectField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Ember.TextField.extend(Radium.FieldValidation, {
      classNames: ['span8'],
      elementId: 'subject',
      nameBinding: 'parentView.fieldAttributes',
      rules: ['required']
    })
  }),

  messageField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Ember.TextArea.extend(Radium.FieldValidation, {
      classNames: ['span8'],
      elementId: 'message',
      nameBinding: 'parentView.fieldAttributes',
      rules: ['required']
    })
  }),

  // Extra field toggles
  isOptionalVisible: false,
  toggleText: function() {
    return (this.get('isOptionalVisible')) ? 'Hide' : 'Show';
  }.property('isOptionalVisible').cacheable(),
  toggleOptional: function() {
    this.toggleProperty('isOptionalVisible');
    if (!this.get('isOptionalVisible')) {
      this.setPath('ccEmailValues.selected', []);
      this.setPath('bccEmailValues.selected', []);
    }
    return false;
  },

  selectedCCEmails: Ember.View.extend({
    contentBinding: 'parentView.ccEmailValues.selected'
  }),

  selectedBCCEmails: Ember.View.extend({
    contentBinding: 'parentView.bccEmailValues.selected'
  }),

  ccField: Radium.Fieldset.extend({
    formField: Radium.AutocompleteTextField.extend({
      elementId: 'cc',
      classNames: ['span3'],
      nameBinding: 'parentView.fieldAttributes',
      storedCCBinding: 'parentView.parentView.ccEmailValues',
      sourceBinding: 'storedCC.content',
      select: function(event, ui) {
        if (ui.item) {
          this.getPath('storedCC.selected').pushObject(ui.item.target);
        }
        return false;
      },
      close: function() {
        this.set('value', null);
      },
      change: function(event, ui) {
        var val = this.get('value');
        if (!ui && val) {
          var nonSystemEmail = Ember.Object.create({
                email: val
              });
            this.getPath('storedCC.selected').addObject(nonSystemEmail);
        } else {
          return false;
        }
        this.set('value', null);
      }
    })
  }),

  bccField: Radium.Fieldset.extend({
    formField: Radium.AutocompleteTextField.extend({
      elementId: 'bcc',
      classNames: ['span3'],
      nameBinding: 'parentView.fieldAttributes',
      storedBCCBinding: 'parentView.parentView.bccEmailValues',
      sourceBinding: 'storedBCC.content',
      select: function(event, ui) {
        if (ui.item) {
          this.getPath('storedBCC.selected').pushObject(ui.item.target);
        }
        return false;
      },
      close: function() {
        this.set('value', null);
      },
      change: function(event, ui) {
        var val = this.get('value');
        if (!ui && val) {
          var nonSystemEmail = Ember.Object.create({
                email: val
              });
            this.getPath('storedBCC.selected').addObject(nonSystemEmail);
        } else {
          return false;
        }
        this.set('value', null);
      }
    })
  }),

  isAttachmentVisible: false,
  toggleAttachmentText: function() {
    return (this.get('isAttachmentVisible')) ? 'Remove' : 'Add';
  }.property('isAttachmentVisible').cacheable(),
  toggleAttachment: function() {
    this.toggleProperty('isAttachmentVisible');
    return false;
  },

  submitForm: function() {
    if (this.get('isValid')) {
      console.log('yay');
      debugger;
    }
  }
});