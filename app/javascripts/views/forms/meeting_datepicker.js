Radium.MeetingFormDatepicker = Radium.DatePickerField.extend({
  didInsertElement: function() {
    this._super();
    this.fire('change');
  },
  elementId: 'start-date',
  viewName: 'meetingStartDate',
  name: 'start-date',
  classNames: ['input-small'],
  minDate: function() {
    return new Date();
  }.property(),
  defaultDate: Ember.DateTime.create(),
  value: function(key, value) {
    if (arguments.length === 1) {
      return this.get('dateValue')
                .toFormattedString('%Y-%m-%d');
    } else {
      var currentDate = this.get('dateValue'),
          date;
      if (value) {
        date = Ember.DateTime.parse(value, '%Y-%m-%d');
      } else {
        date = this.get('defaultDate');
      }

      this.set('dateValue', currentDate.adjust({
        day: date.get('day'),
        month: date.get('month'),
        year: date.get('year')
      }));
      return value;
    }
  }.property('dateValue'),
  deleteSummary: function(){
    var daysSummary = this.getPath('controller.daysSummary'),
        length = daysSummary.get('length');

    for(var i = (length - 1); i >= 0; i--){
      daysSummary.removeObject(daysSummary[i]);
    }
  },

  change: function(){
    this._super();

    $('.progress').show();

    this.deleteSummary();

    var self = this,
        daysSummary = this.getPath('controller.daysSummary'),
        date = Ember.DateTime.parse(this.get('value'), '%Y-%m-%d'),
        dateString = date.toFormattedString("%Y-%m-%d"),
        url = Radium.get('appController').getFeedUrl('users', Radium.getPath('appController.current_user.id'), dateString);


    $.when($.ajax({url: url})).then(function(data){
      $('.progress').hide();
      var meetingsData = Radium.store.loadMany(Radium.Meeting, data.feed.datebook_section.meetings),
          meetings = Radium.store.findMany(Radium.Meeting, meetingsData.ids);
      if (self.get('state') === 'inDOM') {
        self.setPath('controller.daysSummary', meetings);
      }
    });
  }
});