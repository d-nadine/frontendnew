Radium.FeedListView = Ember.View.extend({
  classNames: ['feed-row'],
  layout: Ember.Handlebars.compile('<p>{{#with content}}<strong>{{formatTime timestamp}}</strong> {{yield}}{{/with}}</p>'),
  defaultTemplate: 'default_activity',
  template: Ember.computed(function() {
    var kind = this.getPath('content.kind'),
        tag = this.getPath('content.tag'),
        templateName = [kind, tag].join('_'),
        template = this.templateForName(templateName, 'template');
    return template || this.get('defaultTemplate');
  }).property('content.kind', 'content.tag').cacheable(),

  didInsertElement: function() {
    if (this.getPath('content.isNewActivity')) {
      this.$().addClass('pushed').hide().slideDown('fast', function() {
        $(this).removeClass('pushed');
      });
      // No longer considered a new activity once added to the DOM.
      this.setPath('content.isNewActivity', false);
    }
  }
});