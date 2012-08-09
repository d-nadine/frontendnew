Radium.MeetingForm = Radium.FormView.extend({
  templateName: 'meeting_form',

  // Temp override, remove when ready
  submit: function(event) {
    event.preventDefault();
  },

  init: function() {
    this._super();

    this.set('controller', Radium.MeetingFormController.create({
      view: this,
      usersBinding: 'Radium.everyoneController.emails',
      init: function() {
        this._super();
        this.set('selectedInvitees', Ember.A([]));
      }
    }));
  },

  topicValue: null,
  locationValue: null,
  startsAtValue: null,
  endsAtValue: null,
  daysSummary: Ember.A(),

  topicField: Ember.TextField.extend(Radium.Validate, {
    placeholder: "Meeting description",
    valueBinding: 'parentView.controller.topicValue',
    validate: function() {
      return this.get('value');
    }
  }),

  locationField: Ember.TextField.extend(Radium.Validate, {
    placeholder: "Location",
    valueBinding: 'parentView.controller.locationValue',
    validate: function() {
      return this.get('value');
    }
  }),

  inviteField: Radium.AutocompleteTextField.extend(Radium.EmailFormGroup, {
    controllerBinding: 'parentView.controller',
    sourceBinding: 'controller.users',
    selectedInviteesBinding: 'controller.selectedInvitees',
    placeholder: function() {
      var numOfInvitees = this.getPath('selectedInvitees.length');
      return (numOfInvitees) ? "" : "Invitees";
    }.property('selectedInvitees.length')
  }),

  meetingStartDateField: Radium.MeetingFormDatepicker.extend({
    controllerBinding: 'parentView.controller',
    dateValueBinding: 'controller.startsAtDateValue',
    elementId: 'start-date',
    viewName: 'meetingStartDate',
    name: 'start-date'
  }),

  meetingEndDateField: Radium.MeetingFormDatepicker.extend({
    controllerBinding: 'parentView.controller',
    dateValueBinding: 'controller.endsAtDateValue',
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
    dateDidChange: function() {
      var isoTime = this.get('date').toISO8601();
      if (this.$().timepicker().length) {
        this.$().timepicker('setTime', new Date(isoTime));
      }
    }.observes('date')
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
