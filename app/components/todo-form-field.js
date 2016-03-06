import Ember from 'ember';
import TodoField from 'radium/components/todo-field';

export default TodoField.extend({
  /*attributeBindings: ['readonly'],
  readonlyBinding: 'parentView.isPrimaryInputDisabled',*/
  finishBy: Ember.computed.alias('parentView.finishBy')
});
