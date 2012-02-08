define('views/forms/datepicker', function(require) {
  
  var Radium = require('radium');

  Radium.DatePickerField = Ember.TextField.extend({
    placeholder: "",
    didInsertElement: function() {
      this.$().datepicker();
    }
  });

  return Radium;
});