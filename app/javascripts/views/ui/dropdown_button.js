Radium.DropdownButton = Ember.View.extend({
  tagName: 'button',
  classNames: 'btn btn-small dropdown-toggle'.w(),
  template: Ember.Handlebars.compile('{{title}}<span class="caret"></span>'),
  click: function() {
    this.$().parent().toggleClass('open');
  }
});