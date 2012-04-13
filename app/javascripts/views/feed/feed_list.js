Radium.FeedListView = Ember.View.extend({
  tagName: 'td',
  layout: Ember.Handlebars.compile('{{#with content}}<strong>{{formatTime timestamp}}</strong> {{yield}}{{/with}}'),
  defaultTemplate: 'default_activity',
  template: Ember.computed(function() {
    var kind = this.getPath('content.kind'),
        tag = this.getPath('content.tag'),
        templateName = [kind, tag].join('_'),
        template = this.templateForName(templateName, 'template');
    return template || this.get('defaultTemplate');
  }).property('content.kind', 'content.tag').cacheable()
});