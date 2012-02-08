define('views/forms/autocomplete', function(require) {
  
  var Radium = require('radium');

  Radium.AutocompleteTextField = Radium.TextField.extend(JQ.Widget, {
    uiType: 'autocomplete',
    uiOptions: ['source'],
    uiEvents: ['select', 'focus'],
    select: function(event, ui) {
      this.$().val(ui.item.label);
      this.$().next().val(ui.item.value);
      if ( ui.item ) {
        event.target.value = '';
        event.preventDefault();
      }
    },
    focus: function(event, ui) {
      event.preventDefault();
    }
  });
  return Radium;
});