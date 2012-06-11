Ember.DateTime.reopenClass({
  DifferenceInDays: function(a, b){
    var timeDiff = Math.abs(a.get('_ms') - b.get('_ms'));
    return Math.ceil(timeDiff / (1000 * 3600 * 24));
  }
});
