Radium.MessageForm = Radium.FormView.extend({
  templateName: 'message_form',

  init: function() {
    this._super();

    this.set('toEmailValues', Ember.ArrayController.create({
      contentBinding: 'Radium.everyoneController.emails',
      selected: Ember.A([])
    }));

    this.set('ccEmailValues', Ember.ArrayController.create({
      contentBinding: 'Radium.everyoneController.emails',
      selected: Ember.A([])
    }));

    this.set('bccEmailValues', Ember.ArrayController.create({
      contentBinding: 'Radium.everyoneController.emails',
      selected: Ember.A([])
    }));
    
    this.getPath('toEmailValues.selected').pushObjects(
      this.controller.get('to')
    );
  },

  // TODO: Move 'isValid' prop into other forms once validation kinks worked out.
  isValid: function() {
    return (this.getPath('invalidFields.length')) ? false : true;
  }.property('invalidFields.@each').cacheable(),

  selectedToEmails: Ember.View.extend({
    contentBinding: 'parentView.toEmailValues.selected'
  }),

  toField: Radium.AutocompleteTextField.extend(Radium.EmailFormGroup, {
    elementId: 'to',
    flagType: 'to',
    classNames: ['span3'],
    nameBinding: 'parentView.fieldAttributes',
    selectedGroupBinding: 'parentView.toEmailValues',
    sourceBinding: 'selectedGroup.content'
  }),
  
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

  ccField: Radium.AutocompleteTextField.extend(Radium.EmailFormGroup, {
    elementId: 'cc',
    flagType: 'cc',
    classNames: ['span3'],
    nameBinding: 'parentView.fieldAttributes',
    selectedGroupBinding: 'parentView.ccEmailValues',
    sourceBinding: 'selectedGroup.content'
  }),

  bccField: Radium.AutocompleteTextField.extend(Radium.EmailFormGroup, {
    elementId: 'bcc',
    flagType: 'bcc',
    classNames: ['span3'],
    nameBinding: 'parentView.fieldAttributes',
    selectedGroupBinding: 'parentView.bccEmailValues',
    sourceBinding: 'selectedGroup.content'
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
    var self = this;
    
    if (this.get('isValid')) {
      // Fields
      var to = this.getPath('toEmailValues.selected').getEach('email').uniq(),
          cc = this.getPath('ccEmailValues.selected').getEach('email').uniq(),
          bcc = this.getPath('bccEmailValues.selected').getEach('email').uniq();
          subject = this.$('#subject').val(),
          message = this.$('#message').val();

      if (!to.length) {
        to = [this.getPath('params.target.emailAddresses.firstObject.value')];
      }
      
      Radium.Email.reopenClass({
        url: 'emails',
        root: 'email'
      });

      this.hide();

      var data = {
            to: to,
            cc: cc,
            bcc: bcc,
            subject: subject,
            message: message
          },
          email = Radium.store.createRecord(Radium.Email, data);
      
      Radium.store.commit();
      Radium.Email.reopenClass({
        url: null,
        root: null
      });

      this._super();
    }
    return false;
  }
});