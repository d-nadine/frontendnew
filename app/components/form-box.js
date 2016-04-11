import Ember from 'ember';
import FormBase from 'radium/components/form-base';
import TextareaFocusMixin from 'radium/mixins/textarea-focus-mixin';

export default FormBase.extend(TextareaFocusMixin, {
  //needs: ['userSettings'], rewrite with new style

  //todoForm: Radium.computed.newForm('todo'),
  //noteForm: Radium.computed.newForm('note'),
  //meetingForm: Radium.computed.newForm('meeting'),
  //emailForm: Radium.computed.newForm('email'),
  showTodoForm: Ember.computed.equal('activeForm', 'todo'),
  showNoteForm: Ember.computed.equal('activeForm', 'note'),
  showMeetingForm: Ember.computed.equal('activeForm', 'meeting'),
  showEmailForm: Ember.computed.equal('activeForm', 'email'),
  //settings: Ember.computed.alias('controllers.userSettings.model'),
  //signature: Ember.computed.alias('settings.signature'),
  template: null,
  activeForm: 'todo',

  setup: Ember.on('init', function() {
    let parent = this.get('parent');
    if(!parent) {
      return;
    }
    return parent.on('formChanged', this, 'onFormChanged');
  }),

  onFormChanged(form) {
    let formName, observer;
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

  actions: {
    showForm(form) {
      this.get(`${form}Form`).reset();
      this.set('activeForm', form);
      if (this.get('showMeetingForm')) {
        this.set('meetingForm.isExpanded', true);
      }
      return Ember.run.later(() => {
        this.onFocusTopic();
      }, 400);
    },

    submitForm() {
      //let activeForm = this.get(`${this.get('activeForm')}Form`);
      this.EventBus.publish(`${this.get('activeForm')}:formSubmitted`);
      return this.onFocusTopic();
    },

    saveEmail(form) {
      this.get('parent').send("saveEmail", form);
      return false;
    }
  },
});
