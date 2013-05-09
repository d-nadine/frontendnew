Radium.ForwardEmailForm = Radium.EmailForm.extend
  isNew: true

  email: null

  defaults: (->
    subject: "FWD: #{@get('email.subject')}"
    message: """
    >>>> Forward Email
    #{@get('email.message')}
    """
    to: []
    cc: []
    bcc: []
  ).property('email.to', 'email.message')

  isValid: ( ->
    @get('to.length') && @get('subject') && @get('message.length')
  ).property('to.[]', 'subject', 'message')
