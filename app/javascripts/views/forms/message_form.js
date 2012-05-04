Radium.MessageForm = Radium.FormView.extend({
  templateName: 'message_form',

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
    return false;
  },

  messageOptionalFields: Ember.View.extend({
    isVisibleBinding: 'parentView.isOptionalVisible',
    willClearFields: function() {
      if (!this.get('isVisible')) {
        this.$('input:text').val('');
      }
    }.observes('isVisible'),

    ccField: Radium.Fieldset.extend({
      formField: Radium.AutocompleteTextField.extend({
        elementId: 'cc',
        classNames: ['span4'],
        nameBinding: 'parentView.fieldAttributes',
        sourceBinding: 'Radium.everyoneController.emails'
      })
    }),
  }),

  isAttachmentVisible: false,
  toggleAttachmentText: function() {
    return (this.get('isAttachmentVisible')) ? 'Remove' : 'Add';
  }.property('isAttachmentVisible').cacheable(),
  toggleAttachment: function() {
    this.toggleProperty('isAttachmentVisible');
    return false;
  },
  attachmentField: Ember.View.extend({
    isVisibleBinding: 'parentView.isAttachmentVisible',
    willClearFields: function() {
      if (!this.get('isVisible')) {
        this.$('input:file').val('');
      }
    }.observes('isVisible')
  }),

  submitForm: function() {
    console.log('yay');
  }
});