Radium.FormValidation = Ember.Mixin.create({
  init: function() {
    this._super();
    this.set('invalidFields', Ember.A([]));
  },

  isInvalid: function() {
    return (this.getPath('invalidFields.length')) ? true : false;
  }.property('invalidFields.length')
});