Radium.FeedDetailsContainer = Ember.ContainerView.extend(Radium.Slider, {
  childViews: ['commentsView'],

  // Add the comments view.
  commentsView: Radium.InlineCommentsView.extend({
    controllerBinding: 'parentView.parentView.controller',
    contentBinding: 'controller.content'
  }),

  init: function() {
    this._super();

    var type = this.get('type');

    this.set('infoView', Ember.View.create({
      contentBinding: 'parentView.content',
      layoutName: 'details_layout',
      init: function() {
        this._super();
        this.set('templateName', type + '_details');
      }
    }));

    this.get('childViews').insertAt(0, this.get('infoView'));
  }
});