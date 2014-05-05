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
      if person != @get('currentUser') && person.get('repliedTo')?.toLowerCase() != @get('currentUser.repliedTo')?.toLowerCase()
        @get('to').pushObject(person)

    @get('to').pushObject(@get('repliedTo.sender'))

  defaults: Ember.computed 'repliedTo', 'repliedTo.subject', 'repliedTo.toList.[]', ->
    subject: ''
    message: ''
    to: []
    cc: []
    bcc: []
