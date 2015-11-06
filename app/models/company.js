import Ember from 'ember';

import Model from "radium/models/models";

import {primary, primaryAccessor} from "radium/utils/computed";

const Company = Model.extend({
  // activities: DS.hasMany('Radium.Activity', {
  //   inverse: 'companies'
  // }),

  contacts: DS.hasMany('Radium.Contact'),
  emailAddresses: DS.hasMany('Radium.EmailAddress'),
  phoneNumbers: DS.hasMany('Radium.PhoneNumber'),
  addresses: DS.hasMany('Radium.Address'),
  marketCategories: DS.hasMany('Radium.MarketCategory'),
  technologies: DS.hasMany('Radium.Technology'),
  socialProfiles: DS.hasMany('Radium.SocialProfile'),
  deals: DS.hasMany('Radium.Deal'),
  lists: DS.hasMany('Radium.List'),

  primaryContact: DS.belongsTo('Radium.Contact', {
    inverse: 'company'
  }),

  user: DS.belongsTo('Radium.User'),
  name: DS.attr('string'),
  website: DS.attr('string'),
  about: DS.attr('string'),
  avatarKey: DS.attr('string'),
  description: DS.attr('string'),
  companyType: DS.attr('string'),
  employees: DS.attr('string'),
  sector: DS.attr('string'),
  industry: DS.attr('string'),
  industryGroup: DS.attr('string'),
  subindustry: DS.attr('string'),

  displayName: Ember.computed.alias('name'),

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

  //todos: DS.hasMany('Radium.Todo'),
  //meetings: DS.hasMany('Radium.Meeting'),
  //tasks: tasks('todos', 'calls', 'meetings'),

  clearRelationships: function() {
    this.get('contacts').compact().forEach(function(contact) {
      return contact.unloadRecord();
    });
    this.get('tasks').compact().forEach(function(task) {
      return task.unloadRecord();
    });
    return this.get('activities').compact().forEach(function(activity) {
      return activity.unloadRecord();
    });
  }
});

export default Company;

Company.toString = function() {
  return "Radium.Company";
};

