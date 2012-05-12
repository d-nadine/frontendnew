Radium.HistoricalFeedView = Radium.FeedView.extend({
  classNames: ['historical'],
  classNameBindings: [
    'content.kind',
    'content.isTodoFinished:finished',
    'isActionsVisible:expanded',
  ],
  layoutName: 'historical_layout',
  defaultTemplate: 'default_activity',
  template: Ember.computed(function() {
    var kind = this.getPath('content.kind'),
        tag = this.getPath('content.tag'),
        templateName = [kind, tag].join('_'),
        template = this.templateForName(templateName, 'template');
    return template || this.get('defaultTemplate');
  }).property('content.kind', 'content.tag').cacheable()
});