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
    this.$().next().val(ui.item.value);
  },
  close: function(event, ui) {
    debugger;
    return false;
  },
  focus: function(event, ui) {
    console.log('focus');
    return false;
  },
  change: function(event, ui) {
    debugger;
    return false;
  }
});