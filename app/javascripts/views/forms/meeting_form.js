Radium.MeetingForm = Radium.FormView.extend({
  templateName: 'meeting_form',

  init: function() {
    this._super();

    this.set('controller', Ember.Object.create({
      topicValue: null,
      locationValue: null,
      startsAtValue: null,
      endsAtValue: null,
      startsAtDateValue: Ember.DateTime.create(),
      endsAtDateValue: function() {
        return this.get('startsAtDateValue').advance({hour: 1});
      }.property('startsAtDateValue'),
      daysSummary: Ember.A([])
    }));

    this.set('inviteesList', Ember.ArrayController.create({
      contentBinding: 'Radium.everyoneController.emails',
      selected: Ember.A([])
    }));
  },

  willDestroyElement: function() {
    this.get('inviteesList').destroy();
    this.get('controller').destroy();
  },

  topicValue: null,
  locationValue: null,
  startsAtValue: null,
  endsAtValue: null,
  daysSummary: Ember.A(),

  isValid: function() {
    return (this.getPath('invalidFields.length')) ? false : true;
  }.property('invalidFields.@each').cacheable(),

  topicField: Ember.TextField.extend({
    placeholder: "Meeting description",
    valueBinding: 'parentView.controller.topicValue'
  }),

  locationField: Ember.TextField.extend({
    placeholder: "Location",
    valueBinding: 'parentView.controller.locationValue'
  }),

  inviteField: Radium.AutocompleteTextField.extend(Radium.EmailFormGroup, {
    selectedGroupBinding: 'parentView.inviteesList',
    sourceBinding: 'selectedGroup.content',
    placeholder: function() {
      var numOfInvitees = this.getPath('parentView.inviteesList.selected.length');
      return (numOfInvitees) ? "" : "Invitees";
    }.property('parentView.inviteesList.selected.length')
  }),

  selectedInvitees: Ember.View.extend({
    contentBinding: 'parentView.inviteesList.selected'
  }),

  meetingStartDateField: Radium.MeetingFormDatepicker.extend({
    controllerBinding: 'parentView.controller',
    elementId: 'start-date',
    viewName: 'meetingStartDate',
    name: 'start-date'
  }),

  meetingEndDateField: Radium.MeetingFormDatepicker.extend({
    controllerBinding: 'parentView.controller',
    elementId: 'end-date',
    viewName: 'meetingEndDate',
    name: 'end-date'
  }),

  daysActivities: Ember.CollectionView.extend({
    contentBinding: "parentView.controller.daysSummary",
    classNames: ['other-meetings'],
    tagName: 'table',
    isVisible: function() {
      return (this.getPath('parentView.daysSummary')) ? true : false;
    }.property('parentView.daysSummary'),
    emptyView: Ember.View.extend({
      tagName: 'tr',
      classNames: ['no-meetings'],
      template: Ember.Handlebars.compile('<td colspan="2">No meetings scheduled.</td>')
    }),
    itemViewClass: Ember.View.extend({
      tagName: 'tr',
      template: Ember.Handlebars.compile('<td>{{formatTime content.startsAt}}</td><td>{{content.topic}}</td>')
    })
  }),

  startsAtField: Ember.TextField.extend(Radium.TimePicker, {
    classNames: ['time'],
    dateBinding: 'parentView.controller.startsAtDateValue'
  }),

  endsAtField: Ember.TextField.extend(Radium.TimePicker, {
    classNames: ['time'],
    dateBinding: 'parentView.controller.endsAtDateValue',
    startsAtDidChange: function() {
      // debugger;
    }.observes('parentView.startsAtValue')
  }),

  submitForm: function() {
    var meeting,
        self = this,
        topic = this.get('topicValue'),
        location = this.get('locationValue'),
        day = this.getPath('meetingStartDate.value'),
        date = Ember.DateTime.parse(day, '%Y-%m-%d'),
        startsAt = this.get('startsAtValue'),
        endsAt = this.get('endsAtValue'),
        endsAtMeridian = this.$('#end-time-meridian').val(),
        invitees = this.getPath('inviteesList.selected'),

        data = {
          topic: topic,
          startsAt: date.adjust({
            hour: startsAt.getHours(),
            minute: startsAt.getMinutes()
          }),
          endsAt: date.adjust({
            hour: endsAt.getHours(),
            minute: endsAt.getMinutes()
          }),
          location: location,
          invite: invitees.map(function(invitee) {
            if (invitee.get('email')) {
              return invitee.get('email');
            } else {
              return invitee.getPath('emailAddresses.firstObject.value');
            }
          })
        };

    meeting = Radium.store.createRecord(Radium.Meeting, data);

    Radium.store.commit();

    this.get('parentView').close();
    return false;
  }
});
