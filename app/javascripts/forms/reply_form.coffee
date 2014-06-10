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

    to = @get('repliedTo.toList').slice()

    to.pushObject(@get('repliedTo.sender'))

    currentUserEmail = @get('currentUser.email')?.toLowerCase()

    to = to.reject (person) ->
      person.get('email').toLowerCase() == currentUserEmail

    @set('to', to)

  defaults: Ember.computed 'repliedTo', 'repliedTo.subject', 'repliedTo.toList.[]', ->
    subject: ''
    message: ''
    to: []
    cc: []
    bcc: []
