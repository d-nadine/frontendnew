Radium.FormValidation = Ember.Mixin.create({
  invalidFields: Ember.A([]),

  isInvalid: function() {
    return (this.getPath('invalidFields.length')) ? true : false;
  }.property('invalidFields.length')
});