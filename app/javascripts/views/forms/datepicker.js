Radium.DatePickerField = Ember.TextField.extend({
  placeholder: "",
  willInsertElement: function() {
    this.$().datepicker({
      dateFormat: 'yy-mm-dd'
    });
  },
  willDestroyElement: function() {
    this.$().datepicker("destroy");
  }
});