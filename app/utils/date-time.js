import Ember from 'ember';

Date.prototype.readableTimeAgo = function() {
  var milliseconds, ret;
  milliseconds = moment.duration(new Date() - this, "milliseconds");
  ret = milliseconds.humanize();
  if ((this - new Date()) < 0) {
    ret = ret + " ago";
  }
  return ret;
};

Date.prototype.isMinDate = function() {
  return this.getDate() === 1 && this.getMonth() === 0 && this.getFullYear() === 1970;
};

Ember.DateTime.reopen({
  readableTimeAgo: function() {
    return this.toJSDate().readableTimeAgo();
  },
  toMeridianTime: function() {
    return this.toFormattedString('%i:%M %p');
  },
  toDateFormat: function() {
    return this.toFormattedString('%Y-%m-%d');
  },
  toFullFormat: function() {
    return this.toISO8601();
  },
  toLocaleDateString: function() {
    return this.toJSDate().toLocaleDateString();
  },
  toJSDate: function() {
    var jsDate;
    jsDate = new Date();
    jsDate.setTime(this.get('_ms'));
    return jsDate;
  },
  isBetweenDates: function(start, end) {
    if (Ember.DateTime.compareDate(this, start) === -1) {
      return false;
    }
    if (Ember.DateTime.compareDate(this, end) === 1) {
      return false;
    }
    return true;
  },
  isBetween: function(start, end) {
    if (Ember.DateTime.compare(this, start) === -1) {
      return false;
    }
    if (Ember.DateTime.compare(this, end) === 1) {
      return false;
    }
    return true;
  },
  isBeforeNow: function() {
    return Ember.DateTime.compare(this, Ember.DateTime.create()) !== 1;
  },
  isBeforeToday: function() {
    var yesterDay;
    yesterDay = Ember.DateTime.create().advance({
      day: -1
    });
    return Ember.DateTime.compareDate(this, yesterDay) !== 1;
  },
  atEndOfDay: function() {
    return this.adjust({
      hour: 23,
      minute: 59,
      second: 59
    });
  },
  atEndOfTomorrow: function() {
    return this.advance({
      day: 1
    }).atEndOfDay();
  },
  atBeginningOfDay: function() {
    return this.adjust({
      hour: 0,
      minute: 0,
      second: 0
    });
  },
  atBeginningOfMonth: function() {
    return this.adjust({
      day: 1,
      hour: 0,
      minute: 0,
      second: 0
    });
  },
  atEndOfMonth: function() {
    return this.advance({
      month: 1
    }).adjust({
      day: 1
    }).advance({
      day: -1
    }).adjust({
      hour: 23,
      minute: 59,
      second: 59
    });
  },
  atEndOfWeek: function() {
    var day;
    day = 7 - this.get('dayOfWeek');
    return this.advance({
      day: day
    }).adjust({
      hour: 0,
      minute: 0,
      second: 0
    });
  },
  daysApart: function(other) {
    var timeDiff;
    timeDiff = other.get('milliseconds') - this.get('milliseconds');
    return Math.floor(timeDiff / (1000 * 3600 * 24));
  },
  isToday: function() {
    return this.toDateFormat() === Ember.DateTime.create().toDateFormat();
  },
  isTomorrow: function() {
    return this.toDateFormat() === Ember.DateTime.create().advance({
      day: 1
    }).toDateFormat();
  },
  isPast: function() {
    return this.get('milliseconds') < Ember.DateTime.create().get('milliseconds');
  },
  isFuture: function() {
    return this.get('milliseconds') > Ember.DateTime.create().get('milliseconds');
  },
  isTheSameDayAs: function(other) {
    return this.toDateFormat() === other.toDateFormat();
  },
  isBeforeYesterday: function() {
    var yesterDay;
    yesterDay = Ember.DateTime.create().advance({
      day: -1
    }).atBeginningOfDay().get('milliseconds');
    return this.get('milliseconds') < yesterDay;
  },
  toHumanFormat: function() {
    var format;
    format = "%A, %B %D %Y";
    if (this.isToday()) {
      return "Today";
    } else if (this.isTomorrow()) {
      return "Tomorrow";
    } else {
      return this.toFormattedString(format);
    }
  },
  toHumanFormatWithTime: function() {
    return (this.toHumanFormat()) + " " + (this.toMeridianTime());
  },
  toBriefFormat: function() {
    return this.toFormattedString("%D %b %y");
  },
  toUnixTimestamp: function() {
    return this.toJSDate().getTime() / 1000;
  },
  getRoundTime: function() {
    var minutes, roundUp;
    minutes = this.toJSDate().getMinutes();
    if (minutes < 30) {
      roundUp = 0 - minutes;
    } else {
      roundUp = 60 - minutes;
    }
    return this.advance({
      minute: roundUp
    });
  },
  nextMonth: function() {
    var date;
    date = this.toJSDate();
    if (date.getMonth() === 11) {
      return Ember.DateTime.create({
        day: 1,
        month: 1,
        year: date.getFullYear() + 1
      });
    } else {
      return Ember.DateTime.create({
        day: 1,
        month: date.getMonth() + 2,
        year: date.getFullYear()
      });
    }
  }
});

Ember.DateTime.reopenClass({
  setRoundTime: function(parent, prop) {
    return parent.set(prop, parent.get(prop).getRoundTime());
  },
  random: function(options) {
    var multipler, randomUpTo;
    if (options == null) {
      options = {};
    }
    multipler = function() {
      if (options.past) {
        return -1;
      } else if (options.future) {
        return 1;
      } else {
        if (Math.random() > 0.5) {
          return 1;
        } else {
          return -1;
        }
      }
    };
    randomUpTo = function(max) {
      return Math.floor((Math.random() * max) + 1);
    };
    return this.create().advance({
      day: randomUpTo(180) * multipler(),
      hour: randomUpTo(24) * multipler(),
      minute: randomUpTo(60) * multipler()
    });
  }
});