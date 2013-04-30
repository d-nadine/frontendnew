Radium.ReplyForm = Radium.EmailForm.extend
  isNew: true
  isReply: true
  showAddresses: false
  showSubject: false

  content: Ember.Object.create()

  email: null

  defaults: (->
    hash = 
      subject: "RE: #{@get('email.subject')}"
      message: ''
      to: []
      cc: []
      bcc: []

    @get('email.to').forEach (person) -> hash.to.pushObject person

    hash
  ).property('email', 'email.subject', 'email.to')

