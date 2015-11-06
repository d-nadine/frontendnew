import Ember from 'ember';

const {
  computed
} = Ember;

import Model from 'radium/models/models';

const Address = Model.extend({
  name: DS.attr('string'),
  isPrimary: DS.attr('boolean'),
  street: DS.attr('string'),
  line2: DS.attr('string'),
  state: DS.attr('string'),
  city: DS.attr('string'),
  country: DS.attr('string'),
  zipcode: DS.attr('string'),

  formatted: computed('street', 'state', 'city', 'country', 'zipcode', function() {
    return [this.get('state'), this.get('city'), this.get('zipcode')].join(' ');
  }),
  value: computed('isNew', 'street', 'line2', 'state', 'city', 'country', 'zipcode', function() {
    if (this.get('isNew')) {
      return;
    }
    return !Ember.isEmpty(this.get('street')) || !Ember.isEmpty(this.get('line2')) || !Ember.isEmpty(this.get('state')) || !Ember.isEmpty(this.get('city')) || !Ember.isEmpty(this.get('zipcode'));
  }),

  getAddressHash: function() {
    return {
      isPrimary: this.get('isPrimary'),
      name: this.get('name'),
      street: this.get('street'),
      line2: this.get('line2'),
      city: this.get('city'),
      state: this.get('state'),
      zipcode: this.get('zipcode'),
      country: this.get('country') || "US",
      isCurrent: this.get('isPrimary')
    };
  },

  toString: function() {
    var parts;
    parts = [this.get('street'), this.get('state'), this.get('line2'), this.get('city'), this.get('country'), this.get('zipcode')].compact();
    if (parts.length) {
      return parts.join(' ');
    } else {
      return "";
    }
  }
});

export default Address;

Address.toString = function() {
  return "Radium.Address";
};
