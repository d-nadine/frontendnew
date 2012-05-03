Radium.FieldSet = Ember.View.extend({
  tagName: 'fieldset',
  classNames: ['control-group'],
  classNameBindings: ['isError:error'],
  
  isError: function() {
    return (this.getPath('errors.length')) ? true : false;
  }.property('errors.@each').cacheable(),
  invalidFieldsBinding: 'parentView.invalidFields',
  attributeBindings: ['for'],
  fieldAttributes: function() {
    return this.get('label').dasherize();
  }.property('label').cacheable(),
  templateName: 'fieldset'
});

Radium.FieldValidation = Ember.Mixin.create({
  isErrorBinding: 'parentView.isError',

  methods: {
    required: function(val) {
      var val = $.trim(val);
      return val.length > 0;
    }
  },

  errorMessages: {
    required: "This field is required."
  },

  keyUp: function(event) {
    this.testRules();
    this._super(event);
  },

  focusOut: function(event) {
    this.testRules();
    this._super(event);
  },

  testRules: function() {
    var rules = this.get('rules'),
        val = this.$().val();

    rules.forEach(function(rule) {
      if (this.get('methods')[rule](val)) {
        this.getPath('parentView.errors').removeObject(this.getPath('errorMessages.'+rule));
        this.getPath('parentView.invalidFields').removeObject(this);
      } else {
        this.getPath('parentView.invalidFields').addObject(this);
        this.getPath('parentView.errors').addObject(this.getPath('errorMessages.'+rule));
      }
    }, this);
  }
})

Radium.MessageForm = Radium.FormView.extend({
  templateName: 'message_form',
  isValid: function() {
    return (this.getPath('invalidFields.length')) ? false : true;
  }.property('invalidFields.@each').cacheable(),
  subjectField: Radium.FieldSet.extend({
    errors: Ember.A([]),
    formField: Ember.TextField.extend(Radium.FieldValidation, {
      classNames: ['span8'],
      elementId: 'subject',
      nameBinding: 'parentView.fieldAttributes',
      rules: ['required']
    })
  }),

  messageField: Radium.FieldSet.extend({
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
    }.observes('isVisible')
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
  })
});