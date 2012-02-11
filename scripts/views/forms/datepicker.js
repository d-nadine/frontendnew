define('views/forms/datepicker', function(require) {
  
  var Radium = require('radium');

  Radium.DatePickerField = Ember.TextField.extend({
    placeholder: "",
    willInsertElement: function() {
      this.$().datepicker();
    },
    willDestroyElement: function() {
      this.$().datepicker("destroy");
    }
  });

  return Radium;
});