Radium.FeedListView = Ember.View.extend({
  tagName: 'td',
  templateName: function() {
    var kind = this.getPath('content.kind'),
        tag = this.getPath('content.tag');
    return [kind, tag].join('_');
  }.property().cacheable()
});