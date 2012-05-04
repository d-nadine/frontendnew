Radium.EmailTokenView = Ember.View.extend({
  classNames: ['span2'],
  removeEmail: function() {
    this.getPath('parentView.content').removeObject(this.get('item'));
  },
  template: Ember.Handlebars.compile('<span class="alert alert-info" {{item.name}} <button class="close" {{action "removeEmail"}}>&times;</button></span>')
})


Radium.MessageForm = Radium.FormView.extend({
  templateName: 'message_form',

  ccEmailValues: Radium.typeAheadController.create({
    contentBinding: 'Radium.everyoneController.emails',
    selected: []
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
    return false;
  },

  selectedCCEmails: Ember.View.extend({
    contentBinding: 'parentView.ccEmailValues.selected'
  }),

  ccField: Radium.Fieldset.extend({
    formField: Radium.AutocompleteTextField.extend({
      elementId: 'cc',
      classNames: ['span4'],
      nameBinding: 'parentView.fieldAttributes',
      storedCCBinding: 'parentView.parentView.ccEmailValues',
      sourceBinding: 'storedCC.content',
      select: function(event, ui) {
        this.getPath('storedCC.selected').pushObject(ui.item.target);
        this.set('value', null);
        event.preventDefault();
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
    console.log('yay');
  }
});