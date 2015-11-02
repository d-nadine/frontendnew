import Model from 'radium/models/models';

import {
  primary
} from '../utils/computed';

import Ember from 'ember';

const {
  computed
} = Ember;

const Contact = Model.extend({
  name: DS.attr('string'),
  title: DS.attr('string'),

  emailAddresses: DS.hasMany('Radium.EmailAddress'),

  primaryEmail: primary('emailAddresses'),

  displayName: computed('name', 'primaryEmail', function() {
    return this.get('name') || this.get('primaryEmail.value');
  }),

  lists: DS.hasMany('Radium.List')
});

export default Contact;

Contact.toString = function() {
  return "Radium.Contact";
};
