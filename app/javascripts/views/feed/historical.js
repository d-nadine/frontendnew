Radium.HistoricalFeedView = Radium.FeedView.extend({
  classNames: ['historical'],
  classNameBindings: [
    'content.kind',
    'content.isTodoFinished:finished',
    'isActionsVisible:expanded',
  ],
  isActionsVisible: false,
  layoutName: 'historical_layout',
  defaultTemplate: 'default_activity',
  init: function() {
    this._super();
    var kind = this.getPath('content.kind'),
        tag = this.getPath('content.tag'),
        templateName = [kind, tag].join('_');

    this.set('templateName', templateName);
  }
});