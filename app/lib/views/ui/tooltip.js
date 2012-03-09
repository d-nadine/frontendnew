/**
  A port of the Twitter Bootstrap Tooltip plugin.

  @requires bootstrap-tooltip.js
  @version  v2.0.1
*/
Radium.TooltipView = Ember.View.extend({
  tagName: 'a',
  attributeBindings: ['title', 'href', 'rel'],
  href: '#',
  rel: 'tooltip',
  template: Ember.Handlebars.compile('<i class="icon-{{unbound icon}}"></i>'),
  didInsertElement: function() {
    this.$().tooltip();
  }
});