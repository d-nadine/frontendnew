Radium.LeadsNewComponent = Ember.Component.extend
  actions:
    modelChanged: (model) ->
      @sendAction 'modelChanged', model

    clearExisting: ->
      @sendAction 'clearExisting'

    saveModel: ->
      @sendAction 'saveModel'

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

  form: null

  showMore: false

  titleQueryParameters: (query) ->
    term: query

  initialize: Ember.on 'init', ->
    @Profileservice.on 'profileQueried', this, 'onProfileQueried'

  onProfileQueried: (contact) ->
    addSocialMedia = (key) =>
      return unless social = contact.get(key)

      @get('model').set(key, {url: social.get('url')})

    ['twitter', 'facebook', 'linkedin'].forEach (s) ->
      addSocialMedia s
