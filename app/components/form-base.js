import Ember from 'ember';
import RadiumComputed from 'radium/lib/radium/computed';

export default Ember.Component.extend(Ember.Evented, {
  actions: {
    toggleFormBox: function() {
      this.toggleProperty('showFormBox');
    },
    toggleExpanded: function() {
      this.toggleProperty('isExpanded');
    }
  },
  justAdded: Ember.computed('content.justAdded', function() {
    return this.get('content.justAdded') === true;
  }),
  isExpandable: Ember.computed('isNew', 'isFinished', 'justAdded', function() {
    return !!!this.get('justAdded');
  }),
  isPrimaryInputDisabled: Ember.computed('isDisabled', 'isExpanded', 'isNew', function() {
    if (this.get('isNew')) {
      return false;
    }
    if (!this.get('isExpanded')) {
      return true;
    }
    return this.get('isDisabled');
  }),
  showComments: Ember.computed('isNew', 'justAdded', function() {
    if (this.get('justAdded')) {
      return false;
    }
    if (this.get('isNew')) {
      return false;
    }
    return true;
  }),
  showSuccess: Ember.computed.alias('justAdded'),
  isDisabled: Ember.computed('model', function() {
    if (this.get('justAdded')) {
      return true;
    }
    return false;
  }),
  hasComments: Ember.computed.notEmpty('comments'),
  showAddAction: Ember.computed.not('isNew'),
  formBox: Ember.computed('todoForm', function() {
    return Radium.FormBox.create({
      todoForm: this.get('todoForm')
    });
  }),
  todoForm: RadiumComputed.newForm('todo'),
  todoFormDefaults: Ember.computed('model', 'tomorrow', function() {
    return {
      reference: this.get('model'),
      finishBy: null,
      user: this.get('currentUser')
    };
  })
});
