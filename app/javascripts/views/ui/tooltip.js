/**
  A port of the Twitter Bootstrap Tooltip plugin.

  @requires bootstrap-tooltip.js
  @version  v2.0.1
*/
Radium.TooltipView = Ember.Button.extend({
  tagName: 'a',
  attributeBindings: ['title', 'href', 'rel'],
  href: '#',
  rel: 'tooltip',
  title: function() {
    return this.get('text') + ' ' + this.get('value');
  }.property('value', 'title').cacheable(),
  click: function() {
    return false;
  },
  template: Ember.Handlebars.compile('<i class="icon-{{unbound icon}}"></i>'),
  didInsertElement: function() {
    this.$().tooltip();
  }
});