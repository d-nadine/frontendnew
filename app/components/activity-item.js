import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

const placeHolders = {
  'note-create': {
    icon: 'notebook'
  }
};


export default Component.extend({
  classNames: ['activity', 'row'],

  note: computed.readOnly('activity.note'),

  editable: computed('note', function() {
    return this.get('note');
  }),

  key: computed('activity', function() {
    const activity = this.get('activity'),
          tag = activity.get('tag'),
          event = activity.get('event');

    return `${tag}-${event}`;
  }),

  icon: computed('activity', 'key', function() {
    if(!placeHolders[this.get('key')]) {
      return 'star';
    }

    return placeHolders[this.get('key')].icon;
  })
});
