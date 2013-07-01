Radium.ForwardEmailForm = Radium.EmailForm.extend
  isNew: true

  email: null

  reset: ->
    @_super.apply this, arguments
    @set('subject', "FWD: #{@get('email.subject')}")
    message = """
    >>>> Forward Email
    #{@get('email.message')}
    """
    @set('message', message)

  defaults: (->
    subject: '' 
    message: ''
    to: []
    cc: []
    bcc: []
  ).property('email')

  isValid: ( ->
    @get('to.length') && @get('subject') && @get('message.length')
  ).property('to.[]', 'subject', 'message')
