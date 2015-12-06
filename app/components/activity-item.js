import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

//TODO: remove this has on next commit
const placeHolders = {
  'contact-create': {
    icon: 'star'
  },
  'company-create': {
    icon: 'star'
  },
  'todo-create': {
    icon: 'star'
  },
  'meeting-create': {
    icon: 'star'
  }
};


export default Component.extend({
  classNames: ['activity', 'row'],

  key: computed('activity', function() {
    const activity = this.get('activity'),
          tag = activity.get('tag'),
          event = activity.get('event');

    return `${tag}-${event}`;
  }),

  icon: computed('activity', 'key', function() {
    //TODO: remove this has on next commit
    if(!placeHolders[this.get('key')]) {
      return 'star';
    }
    return placeHolders[this.get('key')].icon;
  })
});
