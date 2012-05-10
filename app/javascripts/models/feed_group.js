Radium.FeedGroup = Ember.Object.extend({
  content: [],
  date: null,

  hasVisibleContent: function() {
    var ongoing = this.getPath('ongoing.length'),
        historical = this.getPath('historical.length');

    if (ongoing || historical) {
      return true;
    } else {
      return false;
    }
  }.property('ongoing.length', 'historical.length').cacheable()
});