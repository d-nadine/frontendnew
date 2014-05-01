Radium.ReplyForm = Radium.EmailForm.extend
  isNew: true
  isReply: true
  showAddresses: false
  showSubject: false

  email: null

  reset: ->
    @_super.apply this, arguments
    subject = @get('email.subject')

    subject = if /^Re:/i.test(subject) then subject else "RE: #{subject}"

    @set 'subject', subject

    currentUser = @get('currentUser')
    @get('email.toList').forEach (person) =>
      if person != @get('currentUser') && person.get('email')?.toLowerCase() != @get('currentUser.email')?.toLowerCase()
        @get('to').pushObject(person)

    @get('to').pushObject(@get('email.sender'))

  defaults: (->
    subject: ''
    message: ''
    to: []
    cc: []
    bcc: []
  ).property('email', 'email.subject', 'email.toList.[]')

