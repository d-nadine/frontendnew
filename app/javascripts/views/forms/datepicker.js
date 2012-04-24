Radium.DatePickerField = Ember.TextField.extend({
  placeholder: "",
  attributeBindings: ['name'],
  minDate: new Date(),
  willInsertElement: function() {
    this.$().datepicker({
      dateFormat: 'yy-mm-dd',
      minDate: this.get('minDate')
    });
  },
  didInsertElement: function() {
    this.set('_cachedDate', this.get('value'));
  },
  willDestroyElement: function() {
    this.$().datepicker("destroy");
  },
  focusOut: function() {
    this._super();
    if (this.get('value') === '') {
      this.set('value', this.get('_cachedDate'));
    }
  }
});