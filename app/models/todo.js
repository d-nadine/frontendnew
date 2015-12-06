import Model from 'radium/models/models';
import Ember from 'ember';

import {tasks} from 'radium/utils/computed';

const {
  computed
} = Ember;

const Todo = Model.extend({
  user: DS.belongsTo('Radium.User'),

  description: DS.attr('string'),
  finishBy: DS.attr('datetime'),
  isFinished: DS.attr('boolean'),

  _referenceContact: DS.belongsTo('Radium.Contact', {inverse: 'todos'}),
  _referenceDeal: DS.belongsTo('Radium.Deal', {inverse: 'todos'}),
  _referenceEmail: DS.belongsTo('Radium.Email'),
  _referenceMeeting: DS.belongsTo('Radium.Meeting', {inverse: 'todos'}),
  _referenceTodo: DS.belongsTo('Radium.Todo', {inverse: 'todos'}),
  _referenceCompany: DS.belongsTo('Radium.Company'),

  reference: computed('_referenceContact', '_referenceDeal', '_referenceEmail', '_referenceMeeting', '_referenceTodo', '_referenceCompany', {
    get: function() {
      return this.get('_referenceContact') || this.get('_referenceDeal') || this.get('_referenceEmail') || this.get('referenceMeeting') || this.get('_referenceTodo') || this.get('referenceCompany');
    },
    set: function(key, value){
      const property = value.constructor.toString().split('.')[1],
            associationName = `_reference${property}`;

      this.set(associationName, value);
    }
  }),

  activities: DS.hasMany('Radium.Activity', {inverse: '_referenceTodo'}),
  todos: DS.hasMany('Radium.Todo', {inverse: null}),

  time: computed.oneWay('finishBy'),

  overdue: computed('finishBy', function() {
    const finishBy = this.get('finishBy');

    if(this.get('isFinished') || !finishBy) {
      return false;
    }

    return finishBy.isBeforeToday();
  }),

  tasks: tasks('todos'),

  displayName: computed.oneWay('description'),

  clearRelationships() {
    Radium.Activity.all()
      .compact()
      .filter((activity) => {
        return activity.get('_referenceTodo') === this || activity.get('todo') === this;
      })
      .compact()
      .forEach((activity) => {
        activity.unloadRecord();
      });

    this.get('tasks').compact().forEach((task) => {
      task.unloadRecord();
    });

    this.get('todos').compact().forEach((todo) => {
      todo.unloadRecord();
    });

    Radium.Notification.all().compact().forEach((notification) => {
      if(notification.get('_referenceTodo') === this) {
        notification.unloadRecord();
      }
    });
  }
});

Todo.toString = function() {
  return "Radium.Todo";
};

export default Todo;
