Radium.HistoricalFeedView = Radium.FeedView.extend({
  classNames: ['historical'],
  classNameBindings: [
    'content.kind',
    'content.isTodoFinished:finished',
    'isActionsVisible:expanded',
  ],
  isActionsVisible: false,
  layoutName: 'historical_layout',
  defaultTemplate: 'default_activity'
});



