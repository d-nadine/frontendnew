Radium.MeetingForm = Radium.FormView.extend({
  templateName: 'meeting_form',

  topicValue: null,
  locationValue: null,
  startsAtValue: null,
  endsAtValue: null,

  isValid: function() {
    return (this.getPath('invalidFields.length')) ? false : true;
  }.property('invalidFields.@each').cacheable(),

  topicField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Ember.TextField.extend(Radium.FieldValidation, {
      classNames: ['span8'],
      elementId: 'topic',
      nameBinding: 'parentView.fieldAttributes',
      rules: ['required'],
      valueBinding: 'parentView.parentView.topicValue'
    })
  }),

  locationField: Radium.Fieldset.extend({
    formField: Ember.TextField.extend({
      classNames: ['span3'],
      elementId: 'location',
      nameBinding: 'parentView.fieldAttributes',
      valueBinding: 'parentView.parentView.locationValue'
    })
  }),

  inviteesList: Ember.ArrayController.create({
    contentBinding: 'Radium.everyoneController.emails',
    selected: Ember.A([])
  }),

  inviteField: Radium.Fieldset.extend({
    formField: Radium.AutocompleteTextField.extend(Radium.EmailFormGroup, {
      elementId: 'invite',
      flagType: 'invite',
      classNames: ['span3'],
      nameBinding: 'parentView.fieldAttributes',
      selectedGroupBinding: 'parentView.parentView.inviteesList',
      sourceBinding: 'selectedGroup.content'
    })
  }),

  selectedInvitees: Ember.View.extend({
    contentBinding: 'parentView.inviteesList.selected'
  }),

  meetingDateField: Radium.DatePickerField.extend({
    elementId: 'start-date',
    viewName: 'meetingDate',
    name: 'start-date',
    classNames: ['input-small'],
    minDate: function() {
      return new Date();
    }.property().cacheable(),
    defaultDate: Ember.DateTime.create(),
    valueBinding: Ember.Binding.dateTime('%Y-%m-%d')
                  .from('defaultDate')
  }),

  startsAtField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Ember.TextField.extend(Radium.FieldValidation, {
      classNames: ['input-small'],
      elementId: 'starts-at',
      nameBinding: 'parentView.fieldAttributes',
      placeholder: 'eg 1:00',
      rules: ['required'],
      valueBinding: 'parentView.parentView.startsAtValue'
    })
  }),

  endsAtField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Ember.TextField.extend(Radium.FieldValidation, {
      classNames: ['input-small'],
      elementId: 'ends-at',
      nameBinding: 'parentView.fieldAttributes',
      placeholder: 'eg 1:00',
      rules: ['required'],
      valueBinding: 'parentView.parentView.endsAtValue'
    })
  }),

  submitForm: function() {
    var meeting, 
        self = this,
        topic = this.get('topicValue'),
        location = this.get('locationValue'),
        day = this.getPath('meetingDate.value'),
        date = Ember.DateTime.parse(day, '%Y-%m-%d'),
        startsAt = this.get('startsAtValue'),
        startsAtMeridian = this.$('#start-time-meridian').val(),
        endsAt = this.get('endsAtValue'),
        endsAtMeridian = this.$('#end-time-meridian').val(),
        invitees = this.getPath('inviteesList.selected'),

        startsAtTimeArr = Radium.Utils.parseTimeString(startsAt, startsAtMeridian),
        endsAtTimeArr = Radium.Utils.parseTimeString(endsAt, endsAtMeridian),


        data = {
          topic: topic,
          startsAt: date.adjust({
            hour: endsAtTimeArr[0],
            minute: endsAtTimeArr[0]
          }).toISO8601(),
          endsAt: date.adjust({
            hour: startsAtTimeArr[0],
            minute: startsAtTimeArr[0]
          }).toISO8601(),
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