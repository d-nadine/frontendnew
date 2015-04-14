Radium.ForwardEmailForm = Radium.EmailForm.extend
  isNew: true

  email: null

  reset: ->
    @_super.apply this, arguments
    @set('subject', "FWD: #{@get('email.subject')}")
    body = """
    >>>> Forward Email
    #{@get('email.message') || @get('email.html')}
    """
    @set('html', body)

  defaults: Ember.computed 'email', ->
    subject: ''
    html: ''
    to: []
    cc: []
    bcc: []

  isValid: Ember.computed 'to.[]', 'subject', 'html', ->
    @get('to.length') && @get('subject') && @get('html.length')
