import Ember from 'ember';
import RadiumComputed from 'radium/lib/radium/computed';

/** temporary need to find the correct place for subclasses**/
Radium.Form = Ember.ObjectProxy.extend({
  defaults: {},

  init() {
    this.reset();
  },

  reset() {
    if(!this.get('isNew')) {
      return;
    }

    this.get('content').setProperties(this.get('defaults'));
  },

  data: Ember.computed('', function() {
    throw new Error('subclasses of form must override data');
  })
});

Radium.FormBox = Ember.ObjectProxy.extend({
  todoForm: null,
  meetingForm: null,
  noteForm: null,
});

Radium.TodoForm = Radium.Form.extend({
  data: Ember.computed(function() {
    return {
      user: this.get('user'),
      finishBy: this.get('finishBy'),
      reference: this.get('reference'),
      description: this.get('description'),
    };
  }).volatile(),

  type: Ember.computed(function() {
    return Radium.Todo;
  }),

  reset() {
    this._super(...arguments);
    this.set('description', '');
    this.set('submitForm', false);
  },

  isBulk: Ember.computed('reference', function() {
    return Ember.isArray(this.get('reference'));
  }),

  commit() {
    let isBulk = Ember.isArray(this.get('reference'));

    if (isBulk) {
      return this.bulkCommit();
    } else {
      return this.individualCommit();
    }
  },

  individualCommit(deferred) {

    return new Ember.RSVP.Promise((resolve, reject) => {
      if (!this.get('isNew')) {
        return resolve();
      }

      let record = this.get('type').createRecord(this.get('data'));

      record.one('didCreate', (created) => {
        created.set('newTask', true);

        let text = `The Task ${created.get('description')} has been created.`;
        let result = {todo: created, confirmation: text};

        if (this.get('modal')) {
          this.get('closeFunc')()
        }

        Ember.run.next(() => {
          let user = null != created ? created.get('user') : void 0;
          if (user) {
            user.reload();
          }
        });

        return resolve(result);
      });

      record.one('becameInvalid', (result) => {
        return reject(result);
      });

      record.one('becameError', (result) => {
        return reject(`An error has occurred and the ${result.get('typeName')} could not be created.`);
      });

      this.get('store').commit();
    })
  },

  bulkCommit() {
    return new Ember.RSVP.Promise((resolve, reject) => {
      let typeName = this.get('reference.firstObject').humanize();

      this.get('reference').forEach((item) => {
        record = this.get('type').createRecord(this.get('data'))
        record.set('reference', item);
      });
    });

    record.one('didCreate', (record) => {
      if (item == this.get('reference.lastObject')) {
        resolve({confirmation: "The todos have been created"});
      }
    });

    record.one('becameInvalid', (result) => {
      reject(result);
    });

    record.one('becameError', (result)  => {
      reject(`An error has occurred and the ${typeName} could not be created.`);
    });

    this.get('store').commit();
  },
});

export default Ember.Component.extend(Ember.Evented, {

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
  }),

  actions: {
    toggleFormBox: function() {
      this.toggleProperty('showFormBox');
    },
    toggleExpanded: function() {
      this.toggleProperty('isExpanded');
    }
  },
});
