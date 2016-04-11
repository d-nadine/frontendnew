import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

export default Component.extend({
  classNameBindings: ['date:is-valid', 'disabled:is-disabled', 'isInvalid', ':control-box', ':datepicker-control-box'],

  pickerShown: false,
  ignoreEmpty: false,
  leader: 'Due',
  textBinding: 'textToDateTransform',
  disabled: computed.alias('targetObject.isDisabled'),
  isSubmitted: computed.alias('targetObject.isSubmitted'),

  date: computed('datePickerTextField', function() {
    return this.get('datePickerTextField').get('date');
  }),

  datePicker: computed('datePickerTextField', function() {
    return this.get('datePickerTextField').$().data('datepicker');
  }),

  isInvalid: computed('date', 'isSubmitted', function() {
    if (!this.get('isSubmitted')) {
      return false;
    }
    if (Ember.isEmpty(this.get('text')) && !this.get('ignoreEmpty')) {
      return true;
    }
    if (!this.get('date')) {
      return !this.get('ignoreEmpty');
    }
    return this.get('date').isBeforeToday();
  }),

  textToDateTransform: computed('date', function(key, value) {
    if (arguments.length === 2) {

    } else if (!value && this.get('date')) {
      return this.get('date').toHumanFormat();
    } else {
      return value;
    }
  }),

  actions: {
    showPicker() {
      let datePicker = this.get('datePicker');
      let pickerShown = $('.datepicker-days').is(':visible');
      Ember.run.next(() => {
        if (!pickerShown) {
          datePicker.show();
        } else {
          return datePicker.hide();
        }
      });
      return false;
    }
  },
});
