import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

export default Component.extend({
  actions: {
    showPicker: function() {
      var datePicker, pickerShown;
      datePicker = this.get('datePicker');
      pickerShown = $('.datepicker-days').is(':visible');
console.log(this.get('parentView'));
console.log(this.get('parentView.finishBy'));
      Ember.run.next(function() {
        if (!pickerShown) {
          datePicker.show();
        } else {
          return datePicker.hide();
        }
      });
      return false;
    }
  },
  pickerShown: false,
  classNameBindings: ['date:is-valid', 'disabled:is-disabled', 'isInvalid', ':control-box', ':datepicker-control-box'],
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
  ignoreEmpty: false,
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
});
