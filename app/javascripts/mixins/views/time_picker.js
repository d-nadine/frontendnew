Radium.TimePicker = Ember.Mixin.create({
  didInsertElement: function() {
    this.$().timepicker({scrollDefaultNow: true})
      .timepicker('setTime', new Date());
    this.set('formValue', this.$().timepicker('getTime'));
  },
  didValueChange: function() {
    this.set('formValue', this.$().timepicker('getTime'));
  }.observes('value')
});