Radium.AggregateArrayProxy = AggregateArrayProxy = Ember.ArrayProxy.extend({
  init: function() {
    this.set('content', Ember.A());
    this.set('map', Ember.Map.create());
  },

  clear: function() {
    this.set('content', Ember.A());
  },

  destroy: function() {
    this.get('map').forEach(function(array, proxy) {
      proxy.destroy();
    });

    this._super.apply(this, arguments);
  },

  add: function(array) {
    var aggregate = this;

    var proxy = Ember.ArrayProxy.create({
      content: array,
      contentArrayDidChange: function(array, idx, removedCount, addedCount) { 
        var addedObjects = array.slice(idx, idx + addedCount);

        addedObjects.forEach(function(item) {
          // FIXME: Hack why is the same object being added to the aggregate twice
          if(item.get && !item.get('isNew') && !item.get('isError') && !item.get('isLoaded')){
            aggregate.pushObject(item);
          }
        });
      },
      contentArrayWillChange: function(array, idx, removedCount, addedCount) { 
        var removedObjects = array.slice(idx, idx + removedCount);

        removedObjects.forEach(function(item) {
          aggregate.removeObject(item);
        });
      }
    });

    proxy.forEach(function(item) {
      aggregate.pushObject(item);
    });

    this.get('map').set(array, proxy);
  },

  remove: function(array) {
    var aggregate = this;

    array.forEach(function(item) {
      aggregate.removeObject(item);
    });

    this.get('map').remove(array);
  }
});
