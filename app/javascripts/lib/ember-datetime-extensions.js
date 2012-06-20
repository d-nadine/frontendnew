Ember.DateTime.reopenClass({
  differenceInDays: function(a, b){
    var timeDiff = a.get('_ms') - b.get('_ms');
    return Math.ceil(timeDiff / (1000 * 3600 * 24));
  },
  isToday: function(date){
    var differenceInDays = Ember.DateTime.differenceInDays(date, Ember.DateTime.create({}));

    return (differenceInDays === 0);
  }
});
