Radium.MeetingForm = Radium.FormView.extend({
  templateName: 'meeting_form',

  topicValue: null,
  locationValue: null,
  startsAtValue: null,
  endsAtValue: null,
  daysSummary: Ember.A(),

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
    init: function(){
      this._super();
      this.deleteSummary();
    },
    elementId: 'start-date',
    viewName: 'meetingDate',
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

      var daysSummary = this.getPath('parentView.daysSummary');

      this.deleteSummary();

      date = Ember.DateTime.parse(this.get('value'), '%Y-%m-%d');

      dateString = date.toFormattedString("%Y-%m-%d");

      var url =  Radium.get('appController').getFeedUrl('users', Radium.getPath('appController.current_user.id'), dateString);

      $.when($.ajax({url: url})).then(function(data){
        $('.progress').hide();
        daysSummary.pushObject(Ember.Object.create({dateHeader: dateString}));
        
        var dateBookSection =  Radium.Utils.loadDateBook(data.feed.datebook_section);

        if(dateBookSection.length > 0){
          daysSummary.pushObject(dateBookSection);
        }else{
          daysSummary.pushObject(Ember.Object.create({message: "Nothing Scheduled."}));
        }
      });
    }
  }),

  daysActivities: Ember.CollectionView.extend({
    contentBinding: "parentView.daysSummary",
    itemViewClass: "Radium.ClusterListItemView"
  }),

  startsAtField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Ember.TextField.extend(Radium.FieldValidation, Radium.TimePicker, {
      classNames: ['input-small'],
      elementId: 'starts-at',
      nameBinding: 'parentView.fieldAttributes',
      placeholder: 'eg 1:00',
      rules: ['required'],
      formValueBinding: 'parentView.parentView.startsAtValue'
    })
  }),

  endsAtField: Radium.Fieldset.extend({
    errors: Ember.A([]),
    formField: Ember.TextField.extend(Radium.FieldValidation, Radium.TimePicker, {
      classNames: ['input-small'],
      elementId: 'ends-at',
      nameBinding: 'parentView.fieldAttributes',
      placeholder: 'eg 1:00',
      rules: ['required'],
      formValueBinding: 'parentView.parentView.endsAtValue'
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
