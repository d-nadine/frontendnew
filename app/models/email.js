import Ember from 'ember';

import Model from 'radium/models/models';

import {
  aggregate
} from '../utils/computed';

const {
  computed
} = Ember;

const Email = Model.extend({
  subject: DS.attr('string'),
  message: DS.attr('string'),
  html: DS.attr('string'),
  toContacts: DS.hasMany('Radium.Contact'),
  toUsers: DS.hasMany('Radium.User'),
  sendTime: DS.attr('datetime'),

  _senderUser: DS.belongsTo('Radium.User'),
  _senderContact: DS.belongsTo('Radium.Contact'),

  sender: computed('_senderUser', '_senderContact', function(){
    return this.get('_senderUser') || this.get('_senderContact');
  }),

  resolvedSubject: computed('subject', function(){
    return this.get('subject') || "(no subject)";
  }),

  textBody: computed('subject', function() {
    if(this.get('isLoading')) {
      return "loading.....";
    }

    const body = this.get('message') || '';

    if(!body.length) {
      return '';
    }

    return body.replace(/\\n/g, '<br/>')
      .replace(/\\n\\n/g, '<br/><br/>')
      .replace("\n", '<br/>')
      .replace(/\n/g, '<br/>');
  }),

  toList: aggregate('toUsers', 'toContacts'),

  contact: computed('toList.[]', 'sender', function() {
    if(this.get('sender').constructor === Radium.Contact) {
      return this.get('sender');
    }

    if(!this.get('toList.length')) {
      return undefined;
    }

    const contact = this.get('toList').find((c) => {
      return c.constructor === Radium.Contact;
    });

    return contact;
  })
});

export default Email;

Email.toString = function() {
  return "Radium.Email";
};
