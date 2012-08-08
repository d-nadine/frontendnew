Radium.TimePicker = Ember.Mixin.create({
  minTime: function() {
    var date = this.get('date'),
        hours = date.get('hour'),
        minutes = date.get('minute'),
        isToday = Radium.Utils.checkIsToday(date),
        time;

    if (isToday === 0) {
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
      return time.toFormattedString("%i:%M%p");
    } else {
      return "12:30am";
    }
  }.property('date'),
  didInsertElement: function() {
    var minTime = this.get('minTime'),
        isoTime = this.get('date').toISO8601(),
        now = new Date(isoTime),
        hour = now.getHours(),
        minutes = now.getMinutes();

    if (minutes < 30) {
      now.setMinutes(30);
    } else {
      now.setHours(hour + 1);
      now.setMinutes(0);
    }

    this.$().timepicker({
      scrollDefaultNow: true,
      minTime: minTime,
      maxTime: "11:30pm"
    }).timepicker('setTime', now);

    this.set('formValue', this.$().timepicker('getTime'));
  },
  didValueChange: function() {
    this.set('formValue', this.$().timepicker('getTime'));
  }.observes('value')
});