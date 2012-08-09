// TODO: Breakout validation methods/properties into Mixin or Class
Radium.MeetingFormController = Ember.Object.extend(Radium.FormValidation, {
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
    var meeting,
        self = this,
        topic = this.get('topicValue'),
        location = this.get('locationValue'),
        startsAt = this.get('startsAtValue'),
        endsAt = this.get('endsAtValue'),
        invitees = this.get('selectedInvitees'),

        data = {
          topic: topic,
          startsAt: startsAt,
          endsAt: endsAt,
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

    // Probably should be view agnostic
    this.getPath('view.parentView').close();
    return false;
  }
});