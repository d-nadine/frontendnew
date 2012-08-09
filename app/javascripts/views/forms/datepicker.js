Radium.DatePickerField = Ember.TextField.extend({
  placeholder: "",
  attributeBindings: ['name'],
  minDate: new Date(),
  didInsertElement: function() {
    this.set('_cachedDate', this.get('value'));
    this.$().datepicker({
      dateFormat: 'yy-mm-dd',
      minDate: this.get('minDate'),
      constrainInput: true
    });
  },
  willDestroyElement: function() {
    this.$().datepicker("destroy");
    // jQuery UI doesn't seem to want to get rid of this
    $('#ui-datepicker-div').hide();
  },
  focusOut: function() {
    this._super();
    if (this.get('value') === '') {
      this.set('value', this.get('_cachedDate'));
    }
  }
});