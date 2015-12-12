import Ember from 'ember';
import Model from 'radium/models/models';

const {
  computed
} = Ember;

const Activity = Model.extend({
  users: DS.hasMany('Radium.User'),
  contacts: DS.hasMany('Radium.Contact'),
  companies: DS.hasMany('Radium.Company'),

  user: DS.belongsTo('Radium.User', {inverse: 'activities'}),

  tag: DS.attr('string'),
  event: DS.attr('string'),
  description: DS.attr('string'),
  time: DS.attr('datetime'),
  source: DS.attr('string'),
  external: DS.attr('boolean'),
  externalLink: DS.attr('string'),

  note: DS.belongsTo('Radium.Note'),

  _referenceCompany: DS.belongsTo('Radium.Company'),
  _referenceContact: DS.belongsTo('Radium.Contact'),
  _referenceDeal: DS.belongsTo('Radium.Deal'),
  _referenceEmail: DS.belongsTo('Radium.Email'),
  _referenceTodo: DS.belongsTo('Radium.Todo'),
  _referenceMeeting: DS.belongsTo('Radium.Meeting'),
  _referenceInvitation: DS.belongsTo('Radium.Invitation'),

  reference: computed('_referenceCompany', '_referenceContact', '_referenceDeal', '_referenceEmail', '_referenceTodo', '_referenceMeeting', '_referenceInvitation', {
    get: function(){
      return this.get('_referenceCompany') || this.get('_referenceContact') || this.get('_referenceDeal') || this.get('_referenceEmail') || this.get('_referenceTodo') || this.get('_referenceMeeting');
    },
    set: function(key, value){
      const property = value.constructor.toString().split('.')[1],
            associationName = `_reference${property}`;

      this.set(associationName, value);
    }
  })
});

Activity.toString = function() {
  return "Radium.Activity";
};

export default Activity;
