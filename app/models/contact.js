import Model from 'radium/models/models';

import { primary, primaryAccessor } from '../utils/computed';

import Ember from 'ember';

const {
  computed
} = Ember;

const Contact = Model.extend({
  avatarKey: DS.attr('string'),
  name: DS.attr('string'),
  title: DS.attr('string'),
  companyName: DS.attr('string'),
  source: DS.attr('string'),
  about: DS.attr('string'),
  removeCompany: DS.attr('boolean'),
  updateStatus: DS.attr('string'),
  lastActivityAt: DS.attr('datetime'),
  activityTotal: DS.attr('number'),
  nextTaskDate: DS.attr('datetime'),
  website: DS.attr('string'),
  fax: DS.attr('string'),
  gender: DS.attr('string'),
  isPublic: DS.attr('boolean'),
  potentialShare: DS.attr('boolean'),
  isPersonal: Ember.computed.not('isPublic'),

  emailAddresses: DS.hasMany('Radium.EmailAddress'),
  phoneNumbers: DS.hasMany('Radium.PhoneNumber'),
  addresses: DS.hasMany('Radium.Address'),

  primaryEmail: primary('emailAddresses'),
  primaryPhone: primary('phoneNumbers'),
  primaryAddress: primary('addresses'),
  email: primaryAccessor('emailAddresses', 'value', 'primaryEmail'),

  phone: primaryAccessor('phoneNumbers', 'value', 'primaryPhone'),
  city: primaryAccessor('addresses', 'city', 'primaryAddress'),
  street: primaryAccessor('addresses', 'street', 'primaryAddress'),
  line2: primaryAccessor('addresses', 'line2', 'primaryAddress'),
  state: primaryAccessor('addresses', 'state', 'primaryAddress'),
  zipcode: primaryAccessor('addresses', 'zipcode', 'primaryAddress'),

  activities: DS.hasMany('Radium.Activity', {inverse: 'contacts'}),

  company: DS.belongsTo('Radium.Company', {inverse: 'contacts'}),

  displayName: computed('name', 'primaryEmail', function() {
    return this.get('name') || this.get('primaryEmail.value');
  }),

  lists: DS.hasMany('Radium.List'),

  contactInfo: DS.belongsTo('Radium.ContactInfo'),

  twitter: computed('contactInfo.socialProfiles.[]', function() {
    return this.resolveSocialProfile('twitter');
  }),

  facebook: computed('contactInfo.socialProfiles.[]', function() {
    return this.resolveSocialProfile('facebook');
  }),

  linkedin: computed('contactInfo.socialProfiles.[]', function() {
    return this.resolveSocialProfile('linkedin');
  }),

  resolveSocialProfile(key) {
    if(!this.get('contactInfo.socialProfiles.length')) {
      return undefined;
    }

    return this.get('contactInfo.socialProfiles').find((profile) => {
      return profile.get('type') === key;
    });
  }
});

export default Contact;

Contact.toString = function() {
  return "Radium.Contact";
};
