Radium.DatePickerField = Ember.TextField.extend({
  placeholder: "",
  attributeBindings: ['name'],
  willInsertElement: function() {
    this.$().datepicker({
      dateFormat: 'yy-mm-dd'
    });
  },
  willDestroyElement: function() {
    this.$().datepicker("destroy");
  }
});