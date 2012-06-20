Radium.MeetingEditView = Radium.FeedEditView.extend({
  templateName: 'meeting_edit',
  editMeetingDateField: Radium.DatePickerField.extend({
    elementId: 'finish-by-date',
    name: 'finish-by-date',
    classNames: ['input-small'],
    minDate: function() {
      var now = Ember.DateTime.create();
      return (now.get('hour') >= 17) ? '+1d' : new Date();
    }.property().cacheable(),
    valueBinding: Ember.Binding.transform({
      to: function(value, binding) {
        return value.toFormattedString('%Y-%m-%d');
      },
      from: function(value, binding) {
        var newFinishBy = Ember.DateTime.parse(value, "%Y-%m-%d"),
            // Adjust to 5PM due time.
            newFinishByTime = newFinishBy.adjust({hour: 17, minute: 0, second: 0});
        return newFinishByTime;
      }
    }).from('parentView.content.finishBy'),
    change: function() {
      Ember.run.next(function() {
        Radium.store.commit();
      });
      this._super();
    }
  })
});