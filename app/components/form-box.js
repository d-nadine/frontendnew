import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    showForm: function(form) {
      this.get("" + form + "Form").reset();
      this.set('activeForm', form);
      if (this.get('showMeetingForm')) {
        this.set('meetingForm.isExpanded', true);
      }
      return Ember.run.later(this, (function(_this) {
        return function() {
          return _this.trigger('focusTopic');
        };
      })(this), 400);
    },
    submitForm: function() {
      var activeForm;
      activeForm = this.get("" + (this.get('activeForm')) + "Form");
      this.EventBus.publish("" + this.activeForm + ":formSubmitted");
      return this.trigger('focusTopic');
    },
    saveEmail: function(form) {
      this.get('parent').send("saveEmail", form);
      return false;
    }
  },
  activeForm: 'todo',
  showTodoForm: Ember.computed.equal('activeForm', 'todo'),
  showNoteForm: Ember.computed.equal('activeForm', 'note'),
  showMeetingForm: Ember.computed.equal('activeForm', 'meeting'),
  showEmailForm: Ember.computed.equal('activeForm', 'email'),
  needs: ['userSettings'],
  settings: Ember.computed.alias('controllers.userSettings.model'),
  signature: Ember.computed.alias('settings.signature'),
  template: null,
  onFormChanged: function(form) {
    var formName, observer;
    if (!form) {
      return;
    }
    formName = "" + form + "Form";
    observer = (function(_this) {
      return function() {
        if (!_this.get(formName)) {
          return;
        }
        _this.removeObserver('activeForm', observer);
        return _this.send('showForm', form);
      };
    })(this);
    if (this.get(formName)) {
      return observer();
    } else {
      return this.addObserver('activeForm', this);
    }
  },
  setup: Ember.on('init', function() {
    var parent = this.get('parent');
    if(!parent) {
      return;
    }
    return parent.on('formChanged', this, 'onFormChanged');
  })
});