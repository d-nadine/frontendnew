define(function(require) {
  var Radium = require('radium');

  /**
    Ember seems to have issues with bindAttr and nested checkbox's,
    so this view extends Ember's checkbox but overrides the defaultTemplate.
  */
  Radium.Checkbox = Ember.Checkbox.extend({
    tagName: 'span',
    defaultTemplate: Ember.Handlebars.compile('<input type="checkbox" {{bindAttr checked="value" disabled="disabled"}}>')
  });

  return Radium;
});