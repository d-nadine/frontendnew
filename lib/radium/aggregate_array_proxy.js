Radium.AggregateArrayProxy = AggregateArrayProxy = Ember.ArrayProxy.extend({
  init: function() {
    this.set('content', Ember.A());
    this.set('map', Ember.Map.create());
  },

  destroy: function() {
    this.get('map').forEach(function(array, proxy) {
      proxy.destroy();
    });

    this.super.apply(this, arguments);
  },

  add: function(array) {
    var aggregate = this;

    var proxy = Ember.ArrayProxy.create({
      content: array,
      contentArrayDidChange: function(array, idx, removedCount, addedCount) { 
        var addedObjects = array.slice(idx, idx + addedCount);

        addedObjects.forEach(function(item) {
          aggregate.pushObject(item);
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
