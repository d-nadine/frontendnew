Radium.TimePicker = Ember.Mixin.create({
  defaultTime: function() {
    var date = this.get('date'),
        hours = date.get('hour'),
        minutes = date.get('minute'),
        time;

    if (minutes < 30) {
      time = date.adjust({
        minute: 30
      });
    } else {
      time = date.adjust({
        hour: hours+1,
        minute: 0
      });
    }
    return time;
  }.property('date'),

  calcMinTime: function() {
    var defaultTime = this.get('defaultTime'),
        isToday = Radium.Utils.checkIsToday(defaultTime);

    if (isToday === 0) {
      return defaultTime.toFormattedString("%i:%M%p");
    } else {
      return "12:00am";
    }
  },

  calcTime: function(time) {
    var isoTime = this.get('date').toISO8601(),
        now = new Date(isoTime),
        hour = now.getHours(),
        minutes = now.getMinutes();

    if (minutes < 30) {
      now.setMinutes(30);
    } else {
      now.setHours(hour + 1);
      now.setMinutes(0);
    }

    return now;
  },

  didInsertElement: function() {
    var start = this.get('date'),
        isoTime = start.toISO8601(),
        now = new Date(isoTime);

    this.$().timepicker({
      scrollDefaultNow: true,
      minTime: start.toFormattedString('%h:%M%p'),
      maxTime: "11:30pm"
    }).timepicker('setTime', now);

    this.$().on('changeTime', $.proxy(function() {
      var timeValue = this.get('value').toUpperCase(),
          time = Ember.DateTime.parse(timeValue, '%h:%M%p'),
          newHour = time.get('hour'),
          newMin = time.get('minute'),
          dateObj = this.get('date');
      this.set('date', dateObj.adjust({hour: newHour, minute: newMin}));
    }, this));

  },

  willDestroyElement: function() {
    this.$().off('changeTime');
  },

  // value: function(key, value) {
  //   console.log('value binding updated');
  //   if (arguments.length === 1) {
  //     return this.get('date').toFormattedString('%h:%M%p');
  //   } else {
  //     var timeValue = value.toUpperCase(),
  //         time = Ember.DateTime.parse(timeValue, '%h:%M%p'),
  //         newHour = time.get('hour'),
  //         newMin = time.get('minute'),
  //         dateObj = this.get('date');

  //     this.set('date', dateObj.adjust({hour: newHour, minute: newMin}));
  //     console.log('new', newHour, dateObj.get('hour'));
  //     return value;
  //   }
  // }.property('date'),

  // valueDidChange: function() {
    // var timeValue = this.get('value').toUpperCase(),
    //     time = Ember.DateTime.parse(timeValue, '%h:%M%p'),
    //     newHour = time.get('hour'),
    //     newMin = time.get('minute'),
    //     date = this.get('date');

    // this.set('date', date.adjust({hour: newHour, minute: newMin}));
    // console.log(this.get('value'))
  // }.observes('value')
});