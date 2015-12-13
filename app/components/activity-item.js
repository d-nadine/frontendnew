import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

const placeHolders = {
  'contact-new_email': {
    icon: 'mail'
  },
  'contact-sent_email': {
    icon: 'mail'
  },
  'note-create': {
    icon: 'notebook'
  }
};


export default Component.extend({
  classNames: ['activity', 'row'],

  note: computed('activity.tag', function() {
    return this.get('activity.tag') === 'note';
  }),

  email: computed('activity.email', 'activity.email.isLoaded', function() {
    return this.get('activity.email') && this.get('activity.email.isLoaded');
  }),

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
  }),

  referenceActivity: computed('email', 'note', function(){
    return !this.get('email') && !this.get('note');
  })
});
