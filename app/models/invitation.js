import Model from 'radium/models/models';
import Ember from 'ember';

const {
  computed
} = Ember;

const Invitation = Model.extend({
  meeting: DS.belongsTo('Radium.Meeting'),
  email: DS.attr('string'),
  status: DS.attr('string'),

  _personContact: DS.belongsTo('Radium.Contact'),
  _personUser: DS.belongsTo('Radium.User'),

  person: computed('_personUser', '_personContact', {
    get() {
      return this.get('_personUser') || this.get('_personContact');
    },
    set(key, value) {
      const property = value.constructor.toString().split('.')[1],
            associationName = `_person${property}`;

      this.set(associationName, value);
    }
  })
});

Invitation.toString = function() {
  return "Radium.Invitation";
};

export default Invitation;
