Radium.DatePickerField = Ember.TextField.extend({
  placeholder: "",
  willInsertElement: function() {
    this.$().datepicker();
  },
  willDestroyElement: function() {
    this.$().datepicker("destroy");
  }
});