// TODO: Move this to it's own file once POC is completed
// TODO: Breakout validation methods/properties into Mixin or Class
Radium.MeetingFormController = Ember.Object.extend({
  init: function() {
    this._super();
    this.set('invalidFields', Ember.A([]));
  },
  isInvalid: function() {
    // var childViews = this.getPath('view.childViews');
    return (this.getPath('invalidFields.length')) ? true : false;
  }.property('invalidFields.length'),
  topicValue: null,
  locationValue: null,
  startsAtValue: Ember.DateTime.create(),
  endsAtValue: Ember.DateTime.create(),
  // Transform the defaults to a rounded time
  startsAtDateValue: function(key, value) {
    // Getter
    if (arguments.length === 1) {
      var now = this.get('startsAtValue'),
          hour = now.get('hour'),
          minute = now.get('minute'),
          start;

      if (minute < 30) {
        start = now.adjust({
          minute: 30
        });
      } else {
        start = now.adjust({
          hour: hour+1,
          minute: 0
        });
      }
      return start;
    // Setter
    } else {
      this.set('startsAtValue', value);
      return value;
    }
  }.property('startsAtValue'),
  endsAtDateValue: function(key, value) {
    if (arguments.length === 1) {
      return this.get('startsAtDateValue').advance({hour: 1});
    } else {
      this.set('endsAtValue', value);
      return value;
    }
  }.property('startsAtDateValue'),
  daysSummary: Ember.A([]),

  submit: function(event) {
    return false;
  }
});

Radium.Validate = Ember.Mixin.create({
  // Requires a controller attached to the parent view.
  controllerBinding: 'parentView.controller',
  classNameBindings: ['isInvalid:is-error', 'isValid'],
  didInsertElement: function() {
    this._super();
    this.getPath('controller.invalidFields').pushObject(this);
  },
  keyUp: function(event) {
    this._super(event);
    this.runValidation();
  },
  focusOut: function(event) {
    this._super(event);
    this.runValidation();
  },
  runValidation: function() {
    var invalidFields = this.getPath('controller.invalidFields');
    if (this.validate()) {
      this.setProperties({
        isInvalid: false,
        isValid: true
      });
      invalidFields.removeObject(this);
    } else {
      this.setProperties({
        isInvalid: true,
        isValid: false
      });
      if (invalidFields.indexOf(this) === -1) {
        invalidFields.pushObject(this);
      }
    }
  }
});


Radium.MeetingForm = Radium.FormView.extend({
  templateName: 'meeting_form',

  // Temp override, remove when ready
  submit: function(event) {
    event.preventDefault();
  },

  init: function() {
    this._super();

    this.set('controller', Radium.MeetingFormController.create({
      view: this
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

  submitButton: Ember.View.extend(Ember.TargetActionSupport, {
    tagName: 'button',
    controllerBinding: 'parentView.controller',
    target: 'controller',
    action: 'submit',
    disabled: function() {
      return (this.getPath('controller.isValid')) ? false : true;
    }.property('controller.isValid'),
    template: Ember.Handlebars.compile('Save!')
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
