Radium.FeedItemHeadlineView = Ember.View.extend({
  classNames: ['alert', 'alert-block'],
  actionsVisible: false,
  click: function(evt) {
    this.get('parentView').toggleProperty('isDetailsVisible');
  }
});