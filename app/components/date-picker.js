import Ember from 'ember';

// Temporary residing here
Radium.KeyConstantsMixin = Ember.Mixin.create({
  TAB: 9,
  ENTER: 13,
  ESCAPE: 27,
  DELETE: 8,
  SPACE: 32,
  ARROW_DOWN: 40,
  ARROW_UP: 38,
  ARROW_LEFT: 37,
  ARROW_RIGHT: 39,
  OPEN_CURLY_BRACE: 219
});

export default Ember.Component.extend({
  actions: {
    showPicker: () => {
      var view = this.get('dateDisplay');

      var datePicker = this.get('datePicker');

      var pickerShown = $('.datepicker-days').is(':visible');

      Ember.run.next(() => {
        if(!pickerShown) {
          datePicker.show()

          Ember.run.next(() => {
            view.$().get(0)? view.$().get(0).select() : false;
          });
        } else {
          datePicker.hide();
        }
      });

      return false;
    },
  },

  pickerShown: false,

  classNameBindings: [
    'date:is-valid',
    'disabled:is-disabled',
    'isInvalid',
    ':control-box',
    ':datepicker-control-box'
  ],

  leader: 'Due',

  textBinding: 'textToDateTransform',

  disabled: Ember.computed.alias('targetObject.isDisabled'),
  isSubmitted: Ember.computed.alias('targetObject.isSubmitted'),
  ignoreEmpty: false,

  isInvalid: Ember.computed('date', 'isSubmitted', () => {
    if(!this.get('isSubmitted')) {
      return false;
    }
    if(Ember.isEmpty(this.get('text')) && !this.get('ignoreEmpty')) {
      return true;
    }
    if(!this.get('date')) {
      return !this.get('ignoreEmpty');
    }

    return this.get('date').isBeforeToday();
  }),

  textToDateTransform: Ember.computed('date', (key, value) => {
    if(arguments.length == 2) {
      return;
    } else if(!value && this.get('date')) {
      this.get('date').toHumanFormat();
    } else
      return value;
  }),

  humanTextField: Ember.TextField.extend(Radium.KeyConstantsMixin, {
    viewName: 'dateDisplay',
    valueBinding: 'parentView.text',
    disabledBinding: 'targetObject.disabled',
    date: Ember.computed.alias('targetObject.date'),
    classNameBindings: [":date-picker"],
    placeholder: Ember.computed.alias('targetObject.placeholder'),

    init: () => {
      this._super.apply(this, arguments);
      allowedKeyCodes = Ember.A([this.TAB, this.ENTER, this.ESCAPE, this.DELETE]);
      this.set('allowedKeyCodes', allowedKeyCodes);
    },

    setup: Ember.on('didInsertElement', () => {
      this._super.apply(this, arguments);
      this.addObserver('value', this, 'valueDidChange');
      var nowTemp = new Date();
      var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);

      input = this.$().datepicker({
        onRender: (date) => {
          if(date.valueOf() < now.valueOf()) {
            return 'disabled';
          } else {
            return '';
          }
        }
      });

      var datePicker = input.data('datepicker');

      var modelDate = this.get('date');

      var defaultViewDate = false;
      if(modelDate && !modelDate.isBeforeToday()) {
        defaultViewDate = modelDate.toJSDate();
      } else {
        defaultViewDate = Date.parse('tomorrow');
      }

      var formatNumber = (number) => {
        return ("0" + number).slice(-2);
      }

      formatted = "#{formatNumber(defaultViewDate.getMonth() + 1)}/#{formatNumber(defaultViewDate.getDate())}/#{defaultViewDate.getFullYear()}";
      this.$().datepicker('update', formatted);

      $(".scroll-pane").scroll(() => {
        if(this.$)
          this.$().datepicker("place");
      });

      this.$().off('keyup', datePicker.update);

      this.set('targetObject.datePicker', datePicker);

      input.on('show', this.showDatePicker.bind(this));
      input.on('hide', this.hideDatePicker.bind(this));
      input.on('changeDate', this.changeDatePicker.bind(this));
    }),

    changeDatePicker: (evt) => {
      if(el != this.$()) {
        return;
      }
      var milliseconds = evt.date.add(new Date().getHours() + 1).hours().valueOf();
      this.set('date', Ember.DateTime.create(milliseconds));
      el.data('datepicker').hide();
      var target = this.get('targetObject');

      if(evt.dontSubmit) {
        return;
      }
      if(!target.get('submitForm')) {
        return;
      }

      Ember.run.next(() => {
        target.sendAction('submitForm', this.get('date'));
      });
    },

    hideDatePicker: () => {
      if(this.isDestroyed) {
        return;
      }
    },

    showDatePicker: () => {
      if(this.isDestroyed) {
        return;
      }
    },

    willDestroyElement: () => {
      this._super.apply(this, arguments);
      this.removeObserver('value', this, 'valueDidChange');
      datePicker = this.$().datepicker();
      datePicker.off('show', this.showDatePicker);
      datePicker.off('hide', this.hideDatePicker);
      datePicker.off('changeDate', this.changeDatePicker);
    },

    keyDown: (evt) => {
      var datepicker = this.$().data('datepicker');

      if(!this.$('.datepicker.dropdown-menu').is(':visible')) {
        datepicker.show();
      }

      var keyCode = evt.keyCode;

      if(!this.get('allowedKeyCodes').contains(keyCode)) {
        return;
      }

      var clearDate = () => {
        var targetObject = this.get('targetObject');
        targetObject.set('date', null);
        this.$().datepicker('setValue', null);
        var datepicker = this.$().data('datepicker');
        datepicker.hide();
        datepicker.viewDate = datepicker.date = new Date();

        Ember.run.next(() => {
          targetObject.sendAction("dateCleared");
        });
      };

      var changeDate = () => {
        this.$().trigger({
          type: 'changeDate',
          date: date
        });
      };

      var date = datepicker.date;

      if(keyCode == this.ENTER) {
        Ember.run.next(() => {
          if(!this.$().val()) {
            clearDate();
            return this.get('targetObject').sendAction('submitForm');
          } else {
            changeDate();
          }
        });
      } else if(keyCode == this.ESCAPE) {
        this.resetDateDisplay();
      } else if(keyCode == this.TAB) {
        this.$().data('datepicker').hide();

        this.$('.datepicker').find('a').attr('tabindex','-1');
        var chld1 = this.$().parent().next().children('input:first').get(0);
        if(chld1) {
          chld1.focus();
        }
      } else if(keyCode == this.DELETE) {
        Ember.run.next(() => {
          if(!this.$().val()) {
            clearDate();
          }
        });
        return
      }

      evt.stopPropagation();
      evt.preventDefault();
    },

    resetDateDisplay: () => {
      var originalDate = false;
      if(this.get('date')) {
        originalDate = this.get('date').toJSDate();
      }

      if(originalDate) {
        this.$().datepicker('setValue', originalDate);
        this.set('value', this.get('date').toHumanFormat());
      } else {
        this.set('value', '');
      }

      this.$().data('datepicker').hide();

    },

    valueDidChange: () => {
      var originalDate = '';
      if(this.get('date')) {
        this.get('date').toJSDate();
      }

      var today = Ember.DateTime.create().toJSDate();
      var value = this.get('value')? this.get('value').toLowerCase() : '';
      var datePicker = this.get('datePicker');

      var days = {
        "sat": "saturday",
        "sun": "sunday",
        "mon": "monday",
        "tue": "tuesday",
        "wed": "wednesday",
        "thu": "thursday",
        "fri": "friday"
      };

      if(!value || originalDate? originalDate.isMinDate() : false) {
        this.set('value', null);
        return
      }

      if((value? value.length : false) <= 2 && originalDate) {
        this.$().datepicker('setValue', originalDate);
        return;
      }

      var parsed = Date.parse(value);

      var isDayOfWeek = false;
      for(var k in days) {
        v = days[k];
        if((value? value.indexOf(k): false ) != -1) {
          var parsed = Date.parse(v);
          isDayOfWeek = true;
          break
        }
      }

      if(value == 'next') {
        parsed = Date.today();
      }

      if(parsed && parsed.isBefore(today)) {
        if(isDayOfWeek)
          parsed.add({days: 7})
        else
          parsed.add({years: 1});
      }

      if((parsed && value.indexOf("next") != -1) && parsed.isAfter(today)) {
        if(Date.equals(parsed,Date.today().addDays(7)))
          parsed = parsed.add({days: 0});
        else
          parsed.add({days: 7});
      }

      if(/^\btom(?:o(?:r(?:r(?:ow?)?)?)?)?\b$/i.test(value))
        parsed = Date.parse('tomorrow');

      if(/^\btod(?:ay?)?\b$/i.test(value))
        parsed = Date.today();

      var result = new Date(parsed);

      if(((result.toString() == "Invalid Date") || result.getTime() == 0) && originalDate) {
        this.$().datepicker('setValue', originalDate);
        return;
      }

      if(!result.isMinDate()) {
        return this.$().datepicker('setValue', result);
      }
    },

    focusIn: (e) => {
      Ember.run.next(() => {
        ele = this.$()

        if (!(ele && ele.get(0))) { return; }

        this.$().get(0).select();
      });
    }
  })
})