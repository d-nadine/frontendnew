import Ember from 'ember';

const {
  Service,
  computed,
  compare,
  A: emberArray
} = Ember;

export default Service.extend({
  lists: emberArray(),

  refresh() {
    Radium.List.find({}).then((results) => {
      this.set('lists', results.toArray().slice());
    });
  },

  sortedLists: computed.sort('lists', function(a, b) {
    return compare(a.get('name'), b.get('name'));
  }),

  configurableLists: computed('sortedLists.@each.configurable', function() {
    return this.get('lists').filter((list) => {
      return list.get('configurable');
    });
  }),

  notify() {
    this.notifyPropertyChange('lists');
    this.notifyPropertyChange('sortedLists');
    return this.notifyPropertyChange('configurableLists');
  },

  addList(list) {
    this.get('lists').pushObject(list);
    return this.notify();
  },

  removeList(list) {
    this.get('lists').removeObject(list);
    return this.notify();
  }
});