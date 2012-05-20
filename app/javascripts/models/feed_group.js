Radium.FeedGroup = Ember.Object.extend({
  content: [],
  date: null,

  hasVisibleContent: function() {
    return this.getPath('historical.length');
  }.property('historical.length').cacheable(),

  isToday: function() {
    var today = Ember.DateTime.create().toFormattedString('%Y-%m-%d');
    return this.get('sortValue') === today;
  }.property('sortValue').cacheable(),
  historical: function() {
    var sortValue = this.get('sortValue');
    return Radium.Activity.filter(function(data) {
      var timestamp = data.get('timestamp'),
          lookupDate = timestamp.match(Radium.Utils.DATES_REGEX.monthDayYear);
      return lookupDate[0] === sortValue && data.get('scheduled') !== true;
    })
  }.property().cacheable(),
  sortedHistorical: function() {
    return this.get('historical').slice(0).sort(function(a, b) {
      return a.get('timestamp') - b.get('timestamp');
    });
  }.property('historical.@each').cacheable()
});