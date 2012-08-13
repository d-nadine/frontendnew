Radium.TimePicker = Ember.Mixin.create({
  didInsertElement: function() {
    var start = this.get('date'),
        isoTime = start.toISO8601(),
        now = new Date(isoTime);

    this.$().timepicker({
      scrollDefaultNow: true,
      minTime: start.toFormattedString('%i:%M%p'),
      maxTime: "11:30pm"
    }).timepicker('setTime', now);

    this.$().on('changeTime', $.proxy(function() {
      var timeValue = this.get('value').toUpperCase(),
          time = Ember.DateTime.parse(timeValue, '%i:%M%p'),
          newHour = time.get('hour'),
          newMin = time.get('minute'),
          dateObj = this.get('date');
      this.set('date', dateObj.adjust({hour: newHour, minute: newMin}));
    }, this));

  },

  willDestroyElement: function() {
    this.$().off('changeTime');
  }
});