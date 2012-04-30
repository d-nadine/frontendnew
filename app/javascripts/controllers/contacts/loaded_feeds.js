Radium.loadedContactsFeed = Ember.Object.create({
  content: [],
  store: {},

  find: function(id) {
    return (this.store[id]) ? this.store[id] : null;
  },

  add: function(feed, id) {
    if (!this.store[id]) {
      this.store[id] = feed;
    }
  }
});