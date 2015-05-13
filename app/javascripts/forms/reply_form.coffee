Radium.ReplyForm = Radium.EmailForm.extend
  isNew: true
  isReply: true
  showAddresses: false
  showSubject: false

  repliedTo: null

  repliedToDidChange: Ember.observer 'repliedTo', ->
    unless repliedTo = @get('repliedTo')
      return

    subject = repliedTo.get('subject')

    subject = if /^Re:/i.test(subject) then subject else "RE: #{subject}"

    @set 'subject', subject

    to = repliedTo.get('toContacts').slice()
                  .concat(repliedTo.get('toUsers').slice())

    to.pushObject(repliedTo.get('sender'))

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
