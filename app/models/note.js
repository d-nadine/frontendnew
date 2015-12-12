import Ember from 'ember';
import Model from 'radium/models/models';

const {
  computed
} = Ember;

const Note = Model.extend({
  body: DS.attr('string'),
  user: DS.belongsTo('Radium.User'),
  // FIXME: migrate notifications
  //notifications: DS.hasMany('Radium.Notification', {inverse: '_referenceNote'}),


  _referenceContact: DS.belongsTo('Radium.Contact', {inverse: 'notes'}),
  _referenceDeal: DS.belongsTo('Radium.Deal'),
  _referenceEmail: DS.belongsTo('Radium.Email'),
  _referenceMeeting: DS.belongsTo('Radium.Meeting', {inverse: 'notes'}),
  _referenceTodo: DS.belongsTo('Radium.Todo', {inverse: 'notes'}),
  _referenceCompany: DS.belongsTo('Radium.Company'),

  reference: computed('_referenceContact', '_referenceDeal', '_referenceEmail', '_referenceMeeting', '_referenceTodo', '_referenceCompany', {
    set(key, value) {
      const property = value.constructor.toString().split('.')[1],
            associationName = `_reference${property}`;

      if(!this.get(associationName)) {
        return;
      }

      this.set(associationName, value);
    },
    get() {
      return this.get('_referenceCompany') ||
        this.get('_referenceContact') ||
        this.get('_referenceDeal') ||
        this.get('_referenceEmail') ||
        this.get('_referenceMeeting') ||
        this.get('_referenceTodo');
    }
  }),

  displayName: Ember.computed.oneWay('body'),

  toString() {
    return this.get('body');
  },

  clearRelationships() {
  }
});

Note.toString = function() {
  return "Radium.Note";
};

export default Note;
