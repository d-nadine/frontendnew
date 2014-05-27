Radium.ForwardEmailForm = Radium.EmailForm.extend
  isNew: true

  email: null

  reset: ->
    @_super.apply this, arguments
    @set('subject', "FWD: #{@get('email.subject')}")
    message = """
    >>>> Forward Email
    #{@get('email.message') || @get('email.html')}
    """
    @set('message', message)

  defaults: Ember.computed 'email', ->
    subject: ''
    message: ''
    to: []
    cc: []
    bcc: []

  isValid: Ember.computed 'to.[]', 'subject', 'message', ->
    @get('to.length') && @get('subject') && @get('message.length')
