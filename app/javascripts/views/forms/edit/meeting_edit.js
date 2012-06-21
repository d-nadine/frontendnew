Radium.MeetingEditView = Radium.FeedEditView.extend({
  templateName: 'meeting_edit',
  startsAtBinding: 'parentView.content.startsAt',
  endsAtBinding: 'parentView.content.endsAt',

  editMeetingDateField: Radium.DatePickerField.extend({
    elementId: 'meeting-date',
    name: 'meeting-date',
    viewName: 'meetingDate',
    classNames: ['input-small'],
    minDate: function() {
      var now = Ember.DateTime.create();
      return (now.get('hour') >= 17) ? '+1d' : new Date();
    }.property().cacheable(),
    valueBinding: Ember.Binding.oneWay('parentView.startsAt')
            .transform(function(value) {
              return value.toFormattedString('%Y-%m-%d');
            })
  }),

  startsAtField: Ember.TextField.extend({
    classNames: ['input-small'],
    viewName: 'newStartsAtTime',
    placeholder: 'eg 1:00',
    valueBinding: Ember.Binding.oneWay('parentView.startsAt')
            .transform(function(value) {
              return value.toFormattedString('%i:%M');
            })
  }),

  startsAtMeridianSelect: Ember.Select.extend({
    classNames: ['meridian-select'],
    content: Ember.A([
      {label: 'AM', value: 0},
      {label: 'PM', value: 1}
    ]),
    optionLabelPath: 'content.label',
    optionValuePath: 'content.value',
    viewName: 'startsAtMeridian',
    selectionBinding: Ember.Binding.oneWay('parentView.startsAt')
            .transform(function(value, binding) {
              if (value.toFormattedString('%p') === 'AM') {
                return binding.getPath('content.firstObject');
              } else {
                return binding.getPath('content.lastObject');
              }
            })
  }),

  endsAtField: Ember.TextField.extend({
    classNames: ['input-small'],
    viewName: 'newEndsAtTime',
    placeholder: 'eg 1:00',
    valueBinding: Ember.Binding.oneWay('parentView.endsAt')
            .transform(function(value) {
              return value.toFormattedString('%i:%M');
            })
  }),

  endsAtMeridianSelect: Ember.Select.extend({
    classNames: ['meridian-select'],
    content: Ember.A([
      {label: 'AM', value: 0},
      {label: 'PM', value: 1}
    ]),
    optionLabelPath: 'content.label',
    optionValuePath: 'content.value',
    viewName: 'endsAtMeridian',
    selectionBinding: Ember.Binding.oneWay('parentView.endsAt')
            .transform(function(value, binding) {
              if (value.toFormattedString('%p') === 'AM') {
                return binding.getPath('content.firstObject');
              } else {
                return binding.getPath('content.lastObject');
              }
            })
  }),


  save: function(event) {
    var newDateString = this.getPath('meetingDate.value'),
        newStartsAtTime = this.getPath('newStartsAtTime.value').split(':'),
        startsAtMeridian = this.getPath('startsAtMeridian.selection.value'),
        newEndsAtTime = this.getPath('newEndsAtTime.value').split(':'),
        newStartsAt = Ember.DateTime.parse(newDateString, '%Y-%m-%d').adjust({
          hour: (startsAtMeridian === 1) ? parseInt(newStartsAtTime[0], 10) + 12 : newStartsAtTime[0],
          minute: newStartsAtTime[1]
        }),
        newEndsAt  = Ember.DateTime.parse(newDateString, '%Y-%m-%d').adjust({
          hour: newEndsAtTime[0],
          minute: newEndsAtTime[1]
        });
        
    this.get('content').setProperties({
      startsAt: newStartsAt,
      endsAt: newEndsAt
    });

    Radium.store.commit();
    return false;
  }
});