Radium.BatchViewLoader = Ember.Mixin.create({
  sliceStart: 0,
  inc: 25,
  end: function() {
    return this.get('length') - this.get('inc');
  }.property('content.length'),
  _cache: Ember.A([]),
  batchloadViews: function(){
    if(!this.get('content') || this.getPath('content.length') === 0)
      return;

    Ember.assert('You need to implement a view property', this.get('view'));
    Ember.assert('You need to implement a createChildView function', this.createChildView);

    var self = this;
    this.get('content').forEach(function(item, idx) {
      var view = self.createChildView(item);
      this.get('_cache').pushObject(view);
    }, this);
    Ember.run.next(function() {
      self.staggeredRendering();
    });
  },

  staggeredRendering: function() {
    var self = this,
        view = this.get('view'),
        itemViews = this.get('_cache'),
        sliceStart = this.get('sliceStart'),
        inc = this.get('inc'),
        sliceEnd = sliceStart + inc,
        end = this.get('end');

    var chunk = itemViews.slice(sliceStart, sliceEnd);
    this.set('sliceStart', sliceEnd);
    view.get('childViews').pushObjects(chunk);

    if (sliceStart < end) {
      Ember.run.next(function() {
        self.staggeredRendering();
      });
    }
  }
});
