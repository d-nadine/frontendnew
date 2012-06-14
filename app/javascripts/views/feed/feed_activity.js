Radium.FeedActivityView = Radium.FeedItemView.extend({
  init: function() {
    this._super();
    var content = this.get('content'),
        type = content.get('type'),
        referenceType = content.get('referenceType'),
        // Manual array to keep track of which mixins are needed
        registeredMixins = ['todo'],
        mixin = (registeredMixins.indexOf(type) !== -1) ? Radium[Radium.Utils.stringToModel(type)+'ViewMixin'] : Radium.Noop;

    // Set up the main row header
    this.set('currentView', Radium.FeedHeaderView.create(mixin, {
      // Manually set to content to the activity's nested resource
      contentBinding: 'parentView.content',
      init: function() {
        this._super();
        var referenceString = (referenceType) ? "_"+referenceType : '';
        console.log('feed_' + type + referenceString);
        this.set('templateName', 'feed_' + type + referenceString);
      }
    }));

    // Assign the comments
    this.setPath('commentsController.content', this.getPath('content.comments'));
  }
});
