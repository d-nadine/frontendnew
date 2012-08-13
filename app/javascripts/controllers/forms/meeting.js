
Radium.MeetingFormController = Ember.Object.extend(Radium.FormValidation, {
  init: function() {
    this._super();

    var now = Ember.DateTime.create(),
        hour = now.get('hour'),
        minute = now.get('minute'),
        start = Radium.Utils.roundTime(now);

    this.setProperties({
      startsAtValue: start,
      endsAtValue: start.advance({hour: 1}),
      selectedInvitees: Ember.A([])
    });

  },
  topicValue: null,
  locationValue: null,
  startsAtValue: null,
  endsAtValue: null,

  locations: function() {
    var contacts = this.get('selectedInvitees');

    return contacts.map(function(contact) {
      return contact.getPath('addresses.firstObject.name');
    });
  }.property('selectedInvitees.@each'),

  // Cache the initial starts at value so we calculate the diff when adjusting endsAtValue
  startsAtWillChange: function() {
    var self = this;
    Ember.run.next(function() {
      self.set('_startsAtCache', self.get('startsAtValue'));
    });
  }.observesBefore('startsAtValue'),

  startsAtDidChange: function() {
    var self = this,
        startsAt = this.get('startsAtValue'),
        startsAtHour = startsAt.get('hour'),
        cachedStartsAtHour = this.getPath('_startsAtCache.hour'),
        endsAt = this.get('endsAtValue'),
        endsAtHour = endsAt.get('hour'),
        diff = (startsAtHour - cachedStartsAtHour);

    Ember.run.next(function() {
      self.set('endsAtValue', endsAt.advance({
        hour: (diff) ? diff : 0
      }));
    });
  }.observes('startsAtValue'),

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