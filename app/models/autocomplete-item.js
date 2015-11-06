import Ember from 'ember';
import Model from 'radium/models/models';

const AutocompleteItem = Model.extend({
  name: DS.attr('string'),
  email: DS.attr('string'),
  source: DS.attr('string'),
  avatarKey: DS.attr('string'),
  type: DS.attr('string'),
  displayName: DS.attr('string'),
  count: DS.attr('number'),

  person: Ember.computed('_personUser', '_personContact', 'personCompany', {
    get() {
      return this.get('_personContact') || this.get('_personUser') || this.get('_personCompany');
    },

    set(key, value) {
      const associationName = value.constructor.toString().humanize();

      return this.set(associationName, value);
    }
  }),

  _personContact: DS.belongsTo('Radium.Contact'),
  _personUser: DS.belongsTo('Radium.User'),
  _personCompany: DS.belongsTo('Radium.Company'),
  resourceList: DS.belongsTo('Radium.List'),

  key: Ember.computed('email', 'type', function() {
    return {
      type: this.get('type'),
      email: this.get('email'),
      key: (this.get('email')) + " - " + (this.get('type'))
    };
  }),

  isExternal: Ember.computed('person', function() {
    return Ember.isEmpty(this.get('person'));
  }),

  isList: Ember.computed('type', function() {
    return this.get('type') === 'list';
  }),

  companyName: Ember.computed('_personCompany', function() {
    const company  = this.get('personCompany');
    if (company) {
      return company.get('name');
    }

    return null;
  })
});

export default AutocompleteItem;

AutocompleteItem.toString = function() {
  return "Radium.AutocompleteItem";
};
