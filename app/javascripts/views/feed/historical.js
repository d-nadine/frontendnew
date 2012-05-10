Radium.HistoricalFeedView = Ember.View.extend({
  classNames: ['feed-item'],
  classNameBindings: [
    'content.kind',
    'content.isTodoFinished:finished'
  ],
  layoutName: 'historical_layout',
  defaultTemplate: 'default_activity',
  template: Ember.computed(function() {
    var kind = this.getPath('content.kind'),
        tag = this.getPath('content.tag'),
        templateName = [kind, tag].join('_'),
        template = this.templateForName(templateName, 'template');
    return template || this.get('defaultTemplate');
  }).property('content.kind', 'content.tag').cacheable(),

  iconView: Ember.View.extend({
    tagName: 'i',
    classNameBindings: [
      'todo:icon-check',
      'contact:icon-user'
    ],
    todo: function() {
      return this.getPath('parentView.content.kind') === 'todo';
    }.property('parentView.content.kind').cacheable(),
    contact: function() {
      return this.getPath('parentView.content.kind') === 'contact';
    }.property('parentView.content.kind').cacheable(),
  }),

  // Comments
  commentsView: null,

  isCommentsVisible: false,

  commentsView: null,
  
  toggleComments: function() {
    if (this.get('commentsView')) {
      this.get('commentsView').remove();
      this.set('commentsView', null);
    } else {
      var activity = this.get('content'),
          commentsController = Radium.inlineCommentsController.create({
            activity: activity,
            contentBinding: 'activity.comments'
          }),
          commentsView = Radium.InlineCommentsView.create({
            controller: commentsController,
            contentBinding: 'controller.content'
          });
      this.set('commentsView', commentsView);
      commentsView.appendTo(this.$());
    }
    this.toggleProperty('isCommentsVisible');
  }
});