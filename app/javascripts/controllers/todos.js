Radium.todosController = Ember.ArrayProxy.create({
  content: [],
  add: function(todo) {
    var length = this.get('length'),
        idx = this.binarySearch(todo.get('sortValue'), 0, length);

    this.insertAt(idx, todo);

    todo.addObserver('sortValue', this, 'todoFinishByDidChange');
  },

  remove: function(todo) {
    todo.removeObserver('sortValue', this, 'todoFinishByDidChange');
    this.removeObject(todo);
  },

  binarySearch: function(value, low, high) {
    var mid, midValue;

    if (low === high) {
      return low;
    }

    mid = low + Math.floor((high - low) / 2);
    midValue = this.objectAt(mid).get('sortValue');

    if (value < midValue) {
      return this.binarySearch(value, mid+1, high);
    } else if (value > midValue) {
      return this.binarySearch(value, low, mid);
    }

    return mid;
  },

  todoFinishByDidChange: function(todo) {
    if (todo.get('isDirty')) {
      this.remove(todo);
      this.add(todo);
    }
  }
})