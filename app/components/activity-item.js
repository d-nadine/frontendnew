import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

const iconMap = {
  'contact-create': 'star'
};

export default Component.extend({
  classNames: ['activity', 'row'],

  icon: computed('activity', function() {
    const activity = this.get('activity'),
          tag = activity.get('tag'),
          event = activity.get('event');

    const key = `${tag}-${event}`;

    return iconMap[key];
  })
});