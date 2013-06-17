require 'forms/meeting_form'

Radium.DevelopmentMeetingFormController = Ember.Controller.extend Radium.CurrentUserMixin,
  needs: ['users']

  newMeeting: Radium.computed.newForm('meeting')

  meetingFormDefaults: (->
    isNew: true
    topic: null
    location: ""
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    user: @get('currentUser')
    startsAt: Ember.DateTime.create()
    endsAt: Ember.DateTime.create().advance({hour: 1})
    invitations: Ember.A()
  ).property('currentUser')

  editableMeeting: ( ->
    meeting = Radium.Meeting.find().toArray().find (m) ->
        m.get("todos.length") > 1

    Radium.MeetingForm.create
      content: meeting
  ).property()

  uneditableMeeting: (->
    users = Radium.User.find().slice(3, 6)
    Radium.MeetingForm.create
      content: Factory.createObject 'meeting',
        topic: 'Uneditable Meeting'
        user: @get('currentUser')
        users: users
        contacts: []
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: 3)
        endsAt: Ember.DateTime.create().advance(day: 3).advance(hour: 3)
        isEditable: false
  ).property()

  editablePassedMeeting: ( ->
    users = Radium.User.find().slice(4, 7)
    meeting = Radium.MeetingForm.create
      content: Factory.createObject 'meeting',
        user: @get('currentUser')
        users: users
        contacts: []
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: -7)
        endsAt: Ember.DateTime.create().advance(day: -7).advance(hour: 3)
        isEditable: true
    meeting
  ).property()

  uneditablePassedMeeting: ( ->
    users = Radium.User.find().slice(2, 4)
    Radium.MeetingForm.create
      content: Factory.createObject 'meeting',
        user: @get('currentUser')
        users: users
        contacts: []
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: -7)
        endsAt: Ember.DateTime.create().advance(day: -7).advance(hour: 3)
        isEditable: false
  ).property()

  justAddedMeeting: ( ->
    users = Radium.User.find().slice(2, 4)
    Radium.MeetingForm.create
      content: Factory.createObject 'meeting',
        user: @get('currentUser')
        users: users
        contacts: []
        location: 'Apple Inc.'
        startsAt: Ember.DateTime.create().advance(day: 17)
        endsAt: Ember.DateTime.create().advance(day: 17).advance(hour: 3)
        isEditable: false
      justAdded: true
  ).property()
