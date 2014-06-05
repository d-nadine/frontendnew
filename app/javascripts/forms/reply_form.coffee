Radium.ReplyForm = Radium.EmailForm.extend
  isNew: true
  isReply: true
  showAddresses: false
  showSubject: false

  repliedTo: null

  reset: ->
    @_super.apply this, arguments
    subject = @get('repliedTo.subject')

    subject = if /^Re:/i.test(subject) then subject else "RE: #{subject}"

    @set 'subject', subject

    currentUser = @get('currentUser')
    @get('repliedTo.toList').forEach (person) =>
      if person != @get('currentUser') && person.get('email')?.toLowerCase() != @get('currentUser.email')?.toLowerCase()
        @get('to').pushObject(person)

    sender = @get('repliedTo.sender')

    @get('to').pushObject() unless sender.get('email') == currentUser.get('email')

  defaults: Ember.computed 'repliedTo', 'repliedTo.subject', 'repliedTo.toList.[]', ->
    subject: ''
    message: ''
    to: []
    cc: []
    bcc: []
