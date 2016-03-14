import Ember from 'ember';

import KeyConstantsMixin from 'radium/mixins/key-constants-mixin';

const {
  TextField
} = Ember;

export default TextField.extend(KeyConstantsMixin, {
  valueBinding: 'parentView.text',
  disabledBinding: 'targetObject.disabled',
  date: Ember.computed(function() {
    let date = new Date(this.$().data('datepicker').date);
    let embdate = Ember.DateTime.create(date);
    embdate.timezone = 0;
    return embdate;
  }),
  classNameBindings: [":date-picker"],
  placeholder: Ember.computed.alias('targetObject.placeholder'),
  init: function() {
    var allowedKeyCodes;
    this._super.apply(this, arguments);
    allowedKeyCodes = Ember.A([this.TAB, this.ENTER, this.ESCAPE, this.DELETE]);
    return this.set('allowedKeyCodes', allowedKeyCodes);
  },
  setup: Ember.on('didInsertElement', function() {
    var datePicker, defaultViewDate, formatNumber, formatted, input, modelDate, now, nowTemp;
    this.set('register-as', this);
    this._super.apply(this, arguments);
    this.addObserver('value', this, 'valueDidChange');
    nowTemp = new Date();
    now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
    input = this.$().datepicker({
      onRender: function(date) {
        if (date.valueOf() < now.valueOf()) {
          return 'disabled';
        } else {
          return '';
        }
      }
    });
    datePicker = input.data('datepicker');
    modelDate = this.get('date');
    //defaultViewDate = modelDate && !modelDate.isBeforeToday() ? modelDate.toJSDate() : Date.parse('tomorrow');
    defaultViewDate = new Date(); // temporary code
    formatNumber = function(number) {
      return ("0" + number).slice(-2);
    };
    formatted = "" + (formatNumber(defaultViewDate.getMonth() + 1)) + "/" + (formatNumber(defaultViewDate.getDate())) + "/" + (defaultViewDate.getFullYear());
    this.$().datepicker('update', formatted);
    $(".scroll-pane").scroll((function(_this) {
      return function() {
        if (_this.$()) {
          return _this.$().datepicker("place");
        }
      };
    })(this));
    this.$().off('keyup', datePicker.update);
    this.set('targetObject.datePicker', datePicker);
    input.on('show', this.showDatePicker.bind(this));
    input.on('hide', this.hideDatePicker.bind(this));
    return input.on('changeDate', this.changeDatePicker.bind(this));
  }),
  // changeDatePicker: function(evt) {
  changeDatePicker: function() {
    var el;//, milliseconds, target;
    if (!(el = this.$())) {
      return;
    }
    /*milliseconds = evt.date.add(new Date().getHours() + 1).hours().valueOf();
    this.set('date', Ember.DateTime.create(milliseconds));
    el.data('datepicker').hide();
    target = this.get('targetObject');
    if (evt.dontSubmit) {
      return;
    }
    if (!target.get('submitForm')) {
      return;
    }
    return Ember.run.next((function(_this) {
      return function() {
        return target.sendAction('submitForm', _this.get('date'));
      };
    })(this));*/
  },
  hideDatePicker: function() {
    if (this.isDestroyed) {

    }
  },
  showDatePicker: function() {
    if (this.isDestroyed) {

    }
  },
  willDestroyElement: function() {
    var datePicker;
    this._super.apply(this, arguments);
    this.removeObserver('value', this, 'valueDidChange');
    datePicker = this.$().datepicker();
    datePicker.off('show', this.showDatePicker);
    datePicker.off('hide', this.hideDatePicker);
    return datePicker.off('changeDate', this.changeDatePicker);
  },
  keyDown: function(evt) {
    var changeDate, clearDate, date, datepicker, keyCode, _ref;
    datepicker = this.$().data('datepicker');
    if (!this.$('.datepicker.dropdown-menu').is(':visible')) {
      datepicker.show();
    }
    keyCode = evt.keyCode;
    if (!this.get('allowedKeyCodes').contains(keyCode)) {
      return;
    }
    clearDate = (function(_this) {
      return function() {
        var targetObject;
        targetObject = _this.get('targetObject');
        targetObject.set('date', null);
        _this.$().datepicker('setValue', null);
        datepicker = _this.$().data('datepicker');
        datepicker.hide();
        datepicker.viewDate = datepicker.date = new Date();
        return Ember.run.next(function() {
          return targetObject.sendAction("dateCleared");
        });
      };
    })(this);
    changeDate = (function(_this) {
      return function() {
        return _this.$().trigger({
          type: 'changeDate',
          date: date
        });
      };
    })(this);
    date = datepicker.date;
    if (keyCode === this.ENTER) {
      Ember.run.next((function(_this) {
        return function() {
          if (!_this.$().val()) {
            clearDate();
            return _this.get('targetObject').sendAction('submitForm');
          } else {
            return changeDate();
          }
        };
      })(this));
    } else if (keyCode === this.ESCAPE) {
      this.resetDateDisplay();
    } else if (keyCode === this.TAB) {
      this.$().data('datepicker').hide();
      this.$('.datepicker').find('a').attr('tabindex', '-1');
      if ((_ref = this.$().parent().next().children('input:first').get(0)) != null) {
        _ref.focus();
      }
    } else if (keyCode === this.DELETE) {
      Ember.run.next((function(_this) {
        return function() {
          if (!_this.$().val()) {
            return clearDate();
          }
        };
      })(this));
      return;
    }
    evt.stopPropagation();
    return evt.preventDefault();
  },
  resetDateDisplay: function() {
    var originalDate;
    originalDate = this.get('date') ? this.get('date').toJSDate() : void 0;
    if (originalDate) {
      this.$().datepicker('setValue', originalDate);
      this.set('value', this.get('date').toHumanFormat());
    } else {
      this.set('value', '');
    }
    return this.$().data('datepicker').hide();
  },
  valueDidChange: function() {
    var datePicker, days, isDayOfWeek, k, originalDate, parsed, result, today, v, value, _ref, _ref1;
    originalDate = (_ref = this.get('date')) != null ? _ref.toJSDate() : void 0;
    today = Ember.DateTime.create().toJSDate();
    value = (_ref1 = this.get('value')) != null ? _ref1.toLowerCase() : void 0;
    datePicker = this.get('datePicker');
    days = {
      "sat": "saturday",
      "sun": "sunday",
      "mon": "monday",
      "tue": "tuesday",
      "wed": "wednesday",
      "thu": "thursday",
      "fri": "friday"
    };
    if (!value || (originalDate != null ? originalDate.isMinDate() : void 0)) {
      this.set('value', null);
      return;
    }
    if ((value != null ? value.length : void 0) <= 2 && originalDate) {
      this.$().datepicker('setValue', originalDate);
      return;
    }
    parsed = Date.parse(value);
    for (k in days) {
      v = days[k];
      if ((value != null ? value.indexOf(k) : void 0) !== -1) {
        parsed = Date.parse(v);
        isDayOfWeek = true;
        break;
      }
    }
    if (value === 'next') {
      parsed = Date.today();
    }
    if (parsed && parsed.isBefore(today)) {
      if (isDayOfWeek) {
        parsed.add({
          days: 7
        });
      } else {
        parsed.add({
          years: 1
        });
      }
    }
    if ((parsed && value.indexOf("next") !== -1) && parsed.isAfter(today)) {
      if (Date.equals(parsed, Date.today().addDays(7))) {
        parsed = parsed.add({
          days: 0
        });
      } else {
        parsed.add({
          days: 7
        });
      }
    }
    if (/^\btom(?:o(?:r(?:r(?:ow?)?)?)?)?\b$/i.test(value)) {
      parsed = Date.parse('tomorrow');
    }
    if (/^\btod(?:ay?)?\b$/i.test(value)) {
      parsed = Date.today();
    }
    result = new Date(parsed);
    if (((result.toString() === "Invalid Date") || result.getTime() === 0) && originalDate) {
      this.$().datepicker('setValue', originalDate);
      return;
    }
    if (!result.isMinDate()) {
      return this.$().datepicker('setValue', result);
    }
  },
  focusIn: function() {
    return Ember.run.next((function(_this) {
      return function() {
        var ele;
        ele = _this.$();
        if (!(ele && (ele != null ? ele.get(0) : void 0))) {
          return;
        }
        return _this.$().get(0).select();
      };
    })(this));
  }
});
