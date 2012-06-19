Radium.FeedActivityView = Radium.FeedItemView.extend({
  init: function() {
    this._super();
    var content = this.get('content'),
        type = content.get('type'),
        referenceType = content.get('referenceType'),
        // Manual array to keep track of which mixins are needed
        registeredMixins = ['todo'],
        mixin = (registeredMixins.indexOf(type) !== -1) ? Radium[Radium.Utils.stringToModel(type)+'ViewMixin'] : Radium.Noop,
        contact = null;

    // Embed a contact if referenced
    if (referenceType === "contact") {
      contact = Radium.store.find(Radium.Contact, content.getPath('reference.contact.id'));
    }

    // Set up the main row header
    this.set('currentView', Radium.FeedHeaderView.create(mixin, {
      // Manually set to content to the activity's nested resource
      contentBinding: 'parentView.content',
      contact: contact,
      init: function() {
        this._super();
        var referenceString = (referenceType) ? "_"+referenceType : '';
        this.set('templateName', 'feed_' + type + referenceString);
      }
    }));

    if (type !== 'todo') {
      this.set('infoView', Ember.View.create({
        isVisibleBinding: 'parentView.isActionsVisible',
        content: this.get('content'),
        layoutName: 'details_layout',
        templateName: type + '_details'
      }));
    }

    // Assign the comments
    this.setPath('commentsController.content', this.getPath('content.comments'));
  }
});
