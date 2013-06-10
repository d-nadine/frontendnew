Radium.ReplyForm = Radium.EmailForm.extend
  isNew: true
  isReply: true
  showAddresses: false
  showSubject: false

  email: null

  defaults: (->
    hash =
      subject: "RE: #{@get('email.subject')}"
      message: ''
      to: []
      cc: []
      bcc: []

    @get('email.toList').forEach (person) -> hash.to.pushObject person

    hash
  ).property('email', 'email.subject', 'email.toList.[]')

