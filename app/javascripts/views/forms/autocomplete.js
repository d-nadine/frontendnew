Radium.AutocompleteTextField = Radium.TextField.extend(JQ.Widget, {
  uiType: 'autocomplete',
  uiOptions: ['source'],
  uiEvents: ['select', 'focus', 'change', 'close'],
  select: function(event, ui) {
    if ( ui.item ) {
      event.target.value = '';
      event.preventDefault();
    }
    this.$().val(ui.item.label);
  },
  close: function(event, ui) {
    return false;
  },
  focus: function(event, ui) {
    event.preventDefault();
  },
  change: function(event, ui) {
    return false;
  }
});