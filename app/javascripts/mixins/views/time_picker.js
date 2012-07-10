Radium.TimePicker = Ember.Mixin.create({
  didInsertElement: function() {
    this.$().timepicker({scrollDefaultNow: true});
  },
  didValueChange: function() {
    this.set('formValue', this.$().timepicker('getTime'));
  }.observes('value')
});