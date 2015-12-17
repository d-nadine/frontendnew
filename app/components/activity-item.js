import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

function activityIcon(key) {
  switch(key) {
  case 'contact-new_email':
  case 'contact-sent_email':
    return 'mail';
  case 'contact-open':
  case 'contact-click':
    return 'view';
  case 'note-create':
    return 'notebook';
  case 'deal-assign':
  case 'contact-assign':
    return 'transfer';
  default:
    return 'star';
  }
}


export default Component.extend({
  classNames: ['activity', 'row'],

  note: computed('activity.tag', function() {
    return this.get('activity.tag') === 'note';
  }),

  email: computed('activity.email', 'activity.email.isLoaded', function() {
    return this.get('activity.email') && this.get('activity.email.isLoaded');
  }),

  emailType: computed('activity.email', 'activity.event', function() {
    const activity = this.get('activity');

    if(!activity.get('isLoaded')) {
      return null;
    }

    if(!activity.get('email')) {
      return null;
    }

    return activity.get('event');
  }),

  openedEmail: computed('emailType', 'activity.reference.isLoaded', function() {
    if(!this.get('activity.reference.isLoaded')) {
      return false;
    }

    return ['click', 'open'].contains(this.get('emailType'));
  }),

  clickedLink: computed('emailType', 'openedEmail', function() {
    if(!this.get('openedEmail')) {
      return null;
    }

    return this.get('emailType') === 'click';
  }),

  deliveredEmail: computed('emailType', function() {
    return ['sent_email', 'new_email'].contains(this.get('emailType'));
  }),

  editable: computed('note', function() {
    return this.get('note');
  }),

  key: computed('activity', function() {
    const activity = this.get('activity'),
          tag = activity.get('tag'),
          event = activity.get('event');

    return `${tag}-${event}`.toLowerCase();
  }),

  icon: computed('activity', 'key', function() {
    return activityIcon(this.get('key'));
  }),

  resolvedReference: computed('reference', 'todo', function() {
    const activity = this.get('activity'),
          reference = activity.get('reference');

    if(!reference) {
      return null;
    }

    if(!reference.get('isLoaded')) {
      return null;
    }

    let todo;

    if((todo = activity.get('todo'))) {
      return todo;
    }

    return reference;
  }),

  referenceActivity: computed('email', 'note', function() {
    return !this.get('email') && !this.get('note');
  })
});
