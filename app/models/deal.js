import Model from 'radium/models/models';
import Ember from 'ember';

// import {tasks} from "radium/utils/computed";

const {
  computed
} = Ember;

const Deal = Model.extend({
 currentStatus: DS.belongsTo('Radium.ListStatus'),
  list: DS.belongsTo('Radium.List'),
  statusLastChangedAt: DS.attr('datetime'),
  expectedCloseDate: DS.attr('datetime'),
  user: DS.belongsTo('Radium.User'),

  //todos: DS.hasMany('Radium.Todo'),
  //meetings: DS.hasMany('Radium.Meeting'),

  //activities: DS.hasMany('Radium.Activity'),

  contact: DS.belongsTo('Radium.Contact', {
    inverse: 'deals'
  }),

  company: DS.belongsTo('Radium.Company', {
    inverse: 'deals'
  }),

  contacts: DS.hasMany('Radium.Contact'),
  contactRefs: DS.hasMany('Radium.ContactRef'),
  name: DS.attr('string'),
  description: DS.attr('string'),
  payBy: DS.attr('datetime'),
  value: DS.attr('number'),

  // nextTodo: DS.belongsTo('Radium.Todo', {
  //   inverse: null
  // }),

  // nextTask: computed('nextTodo', function() {
  //   return this.get('nextTodo');
  // }),

  // nextTaskDate: DS.attr('datetime'),

  // nextTaskDateDisplay: computed('nextTaskDate', function() {
  //   var nextDate;
  //   if (nextDate = this.get('nextTaskDate')) {
  //     return nextDate.readableTimeAgo();
  //   }
  // }),

  //tasks: Radium.computed.tasks('todos', 'meetings'),

  displayName: computed.alias('name'),

  about: computed.alias('description'),

  reference: computed('_reference', {
    get() {
      return this.get('_referenceEmail');
    },

    set(key, value) {
      const property = value.constructor.toString().split('.')[1];
      const associationName = "_reference" + property;

      return this.set(associationName, value);
    }
  }),

  _referenceEmail: DS.belongsTo('Radium.Email'),

  daysInCurrentState: computed('statusLastChangedAt', function() {
    var lastChange, now, timeDiff;
    if (!(lastChange = this.get('statusLastChangedAt'))) {
      return "N/A";
    }
    now = Ember.DateTime.create();
    timeDiff = Math.ceil((now.get('milliseconds') - lastChange.get('milliseconds')) / (1000 * 60));
    if (timeDiff <= 1) {
      return "A few seconds";
    } else if (timeDiff < 60) {
      return timeDiff + " minute(s)";
    } else if (timeDiff < (24 * 60)) {
      return (Math.floor(timeDiff / 60)) + " hour(s)";
    } else {
      return (Math.floor(timeDiff / (24 * 60))) + " day(s)";
    }
  }),

  longName: computed('name', 'contact', function() {
    var company, name, suffix;
    name = this.get('name');
    if (!this.get('contact')) {
      return name;
    }
    suffix = (company = this.get('contact.company')) ? company.get('displayName') : this.get('contact.displayName');
    return name + " - " + suffix;
  }),

  hasPrimaryContact: computed('contact', function() {
    return this.get('contact.id');
  }),

  clearRelationships: function() {
    if (this.get('contact')) {
      this.get('contact.deals').removeObject(this);
    }
    if (this.get('company')) {
      this.get('company.deals').removeObject(this);
    }
    this.get('tasks').compact().forEach(function(task) {
      return task.unloadRecord();
    });
    this.get('activities').compact().forEach(function(activity) {
      return activity.unloadRecord();
    });
    this.get('attachments').compact().forEach(function(attachment) {
      return attachment.unloadRecord();
    });
    // Radium.Notification.all().compact().forEach(function(notification) {
    //   if (notification.get('_referenceDeal') === this) {
    //     return notification.unloadRecord();
    //   }
    // });

    return this._super(...arguments);
  }
});

export default Deal;

Deal.toString = function() {
  return "Radium.Deal";
};
