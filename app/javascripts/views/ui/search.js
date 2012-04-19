Radium.GlobalSearchTextView = Ember.View.extend({
  classNames: 'span9'.w(),
  template: Ember.Handlebars.compile('{{view searchView}}'),
  searchView: Radium.AutocompleteTextField.extend({
    classNames: ["prependedInput", "span9"],
    placeholder: "Find me...",
    elementId: 'search-box',
    sourceBinding: 'Radium.contactsController.contactNamesWithObject',
    select: function(event, ui) {
      this.$().prop('value', ui.item.label);
      ui.item.contact.set('isRecentlySearchedFor', true);
      Radium.feedByContactController.set('filter', ui.item.contact.get('id'));
    },
    focus: function(event, ui) {
      this.$().val('');
      Radium.feedByContactController.set('filter', null);
    },
    change: function(event, ui) {
      if (this.$().val() === '') {
        Radium.feedByContactController.set('filter', null);
      }
    }
  }),
});