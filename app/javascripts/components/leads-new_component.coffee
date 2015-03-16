Radium.LeadsNewComponent = Ember.Component.extend
  actions:
    modelChanged: (model) ->
      @sendAction 'modelChanged', model

    clearExisting: ->
      @sendAction 'clearExisting'

    saveModel: (skipValidation) ->
      return @sendAction('saveModel') if skipValidation

      @send 'isSubmitted', true

      name = $.trim(@get('model.name') || '')

      emailAddresses = @get('model.emailAddresses').mapProperty('value').reject (e) ->
        Ember.isEmpty(e)

      if Ember.isEmpty(name) && !emailAddresses.get('length')
        @displayValidationError()
        return

      if emailAddresses.compact().any((e) -> !Radium.EMAIL_REGEX.text e)
        @get('targetObject').send 'flashError', 'All email addresses must be valid'
        @send 'flashError', 'all email addresses must be valid.'
        return

      if name.length || emailAddresses.length
        @sendAction('saveModel')

    toggleMore: ->
      @$('.more').slideToggle "medium", =>
        @toggleProperty("showMore")

    queryProfile: (email) ->
      return unless @get('model.isNew')
      @ProfileService.queryProfile email

  classNameBindings: [':form', ':new-lead-form']

  setup: Ember.on 'didInsertElement', ->
    Ember.run.scheduleOnce 'afterRender', this, 'initialise'

  initialise: ->
    @$('.contact-name input[type=text]').focus()

  modelDidChange: Ember.observer 'model', ->
    Ember.run.next =>
      @initialise()

  displayValidationError: ->
    @get('targetObject').send 'flashError', 'You must have at least a name field or at least one valid email address'


  form: null

  showMore: false

  titleQueryParameters: (query) ->
    term: query

  initialize: Ember.on 'init', ->
    @ProfileService.on 'profileQueried', this, 'onProfileQueried'

  onProfileQueried: (contact) ->
    addSocialMedia = (key) =>
      return unless social = contact.get(key)

      @get('model').set(key, {url: social.get('url')})

    ['twitter', 'facebook', 'linkedin'].forEach (s) ->
      addSocialMedia s

  iSubmitted: false
