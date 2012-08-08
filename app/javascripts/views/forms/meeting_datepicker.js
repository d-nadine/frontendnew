Radium.MeetingFormDatepicker = Radium.DatePickerField.extend({
  init: function(){
    this._super();
    this.deleteSummary();
  },
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
  }.property().cacheable(),
  defaultDate: Ember.DateTime.create(),
  valueBinding: Ember.Binding.dateTime('%Y-%m-%d')
                .from('defaultDate'),
  deleteSummary: function(){
    var daysSummary = this.getPath('parentView.daysSummary');

    var length = daysSummary.get('length');

    for(var i = (length - 1); i >= 0; i--){
      daysSummary.removeObject(daysSummary[i]);
    }
  },
  change: function(){
    this._super();

    $('.progress').show();

    this.deleteSummary();

    var self = this,
        daysSummary = this.getPath('parentView.daysSummary'),
        date = Ember.DateTime.parse(this.get('value'), '%Y-%m-%d'),
        dateString = date.toFormattedString("%Y-%m-%d"),
        url = Radium.get('appController').getFeedUrl('users', Radium.getPath('appController.current_user.id'), dateString);


    $.when($.ajax({url: url})).then(function(data){
      $('.progress').hide();
      var meetingsData = Radium.store.loadMany(Radium.Meeting, data.feed.datebook_section.meetings),
          meetings = Radium.store.findMany(Radium.Meeting, meetingsData.ids);

      self.setPath('parentView.daysSummary', meetings);
    });
  }
});