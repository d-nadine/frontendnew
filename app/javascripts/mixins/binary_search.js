Radium.BinarySearch = Ember.Mixin.create({
  binarySearch: function(value, low, high, collection, sortValue) {
    var mid, midValue;

    if (low === high) {
      return low;
    }

    collection = (arguments.length > 3) ? arguments[3] : 'content';
    sortValue = (arguments.length > 4) ? arguments[4] : 'sortValue';

    mid = low + Math.floor((high - low) / 2);
    midValue = this.get(collection).objectAt(mid).get(sortValue);

    if (value < midValue) {
      return this.binarySearch(value, mid+1, high, collection, sortValue);
    } else if (value > midValue) {
      return this.binarySearch(value, low, mid, collection, sortValue);
    }

    return mid;
  }
});
