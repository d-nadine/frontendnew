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
