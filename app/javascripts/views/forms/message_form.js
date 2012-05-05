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
    formField: Radium.AutocompleteTextField.extend(Radium.EmailFormGroup, {
      elementId: 'cc',
      classNames: ['span3'],
      nameBinding: 'parentView.fieldAttributes',
      selectedGroupBinding: 'parentView.parentView.ccEmailValues',
      sourceBinding: 'selectedGroup.content'
    })
  }),

  bccField: Radium.Fieldset.extend({
    formField: Radium.AutocompleteTextField.extend(Radium.EmailFormGroup, {
      elementId: 'bcc',
      classNames: ['span3'],
      nameBinding: 'parentView.fieldAttributes',
      selectedGroupBinding: 'parentView.parentView.bccEmailValues',
      sourceBinding: 'selectedGroup.content',
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