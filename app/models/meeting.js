import Model from 'radium/models/models';
import Ember from 'ember';

import {aggregate} from "radium/utils/computed";

const {
  computed,
  A: emberArray
} = Ember;

const Meeting = Model.extend({
  topic: DS.attr('string'),
  description: DS.attr('string'),
  location: DS.attr('string'),
  startsAt: DS.attr('datetime'),
  endsAt: DS.attr('datetime'),

  cancelled: DS.attr('boolean'),

  invitations: DS.hasMany('Radium.Invitation'),
  _organizerUser: DS.belongsTo('Radium.User'),
  _organizerContact: DS.belongsTo('Radium.Contact'),

  contacts: computed('invitations.[]', 'invitations.@each.person', function() {
    const invitations = this.get('invitations') || [];

    if(!invitations.get('length')) {
      return emberArray();
    }

    return this.get('invitations').filter((invitation) => {
      const person = invitation.get('person');

      if(!person) {
        return false;
      }

      return person.constructor === Radium.Contact;
    }).mapProperty('person');
  }),

  users: computed('invitations.[]', 'invitations.@each.person', function() {
    const invitations = this.get('invitations') || [];

    if(!invitations.get('length')) {
      return emberArray();
    }

    return this.get('invitations').filter((invitation) => {
      const person = invitation.get('person');

      if(!person) {
        return false;
      }

      return person.constructor === Radium.User;
    }).mapProperty('person');
  }),

  organizer: computed('_organizerUser', '_organizerContact', function() {
    return this.get('_organizerUser') || this.get('_organizerContact');
  }),

  participants: aggregate('users', 'contacts'),

  _referenceContact: DS.belongsTo('Radium.Contact'),
  _referenceDeal: DS.belongsTo('Radium.Deal'),
  _referenceEmail: DS.belongsTo('Radium.Email'),
  _referenceTodo: DS.belongsTo('Radium.Todo'),

  reference: computed('_referenceContact', '_referenceDeal', '_referenceEmail', '_referenceTodo', {
    get() {
      return this.get('_referenceContact') || this.get('_referenceDeal') || this.get('_referenceEmail') || this.get('_referenceTodo');
    },
    set: function(key, value){
      const property = value.constructor.toString().split('.')[1],
            associationName = `_reference${property}`;

      this.set(associationName, value);
    }
  }),

  todos: DS.hasMany('Radium.Todo'),
  activities: DS.hasMany('Radium.Activity', {inverse: '_referenceMeeting'}),
  time: computed.oneWay('startsAt'),

  displayName: computed.oneWay('topic'),

  activityInfo: computed('participants.[]', function() {
    const participants = this.get('participants');

    if(!participants.get('length')) {
      return "";
    }

    return `with ${participants.mapProperty('displayName').join(', ')}`;
  }),

  clearRelationships() {
    Radium.Activity.all()
      .compact()
      .filter((activity) => {
        return activity.get('_referenceMeeting') === this || activity.get('todo') === this;
      })
      .compact()
      .forEach((activity) => {
        activity.unloadRecord();
      });

    this.get('tasks').compact().forEach((task) => {
      task.unloadRecord();
    });

    Radium.Notification.all().compact().forEach((notification) => {
      if(notification.get('_referenceMeeting') === this) {
        notification.unloadRecord();
      }
    });
  }
});

Meeting.toString = function() {
  return "Radium.Meeting";
};

export default Meeting;
