Radium.ReplyForm = Radium.EmailForm.extend
  isNew: true
  isReply: true
  showAddresses: false
  showSubject: false

  email: null

  reset: ->
    @_super.apply this, arguments
    @set 'subject', "RE: #{@get('email.subject')}"
    @get('email.toList').forEach (person) => @get('to').pushObject person
    @get('to').pushObject(@get('email.sender'))

  defaults: (->
    subject: '' 
    message: ''
    to: []
    cc: []
    bcc: []
  ).property('email', 'email.subject', 'email.toList.[]')

