Radium.LeadsNewComponent = Ember.Component.extend
  actions:
    modelChanged: (model) ->
      @sendAction 'modelChanged', model

    clearExisting: ->
      @sendAction 'clearExisting'

  classNameBindings: [':form', ':new-lead-form']

  setup: Ember.on 'didInsertElement', ->
    Ember.run.scheduleOnce 'afterRender', this, 'initialise'

  initialise: ->
    @$('.contact-name input[type=text]').focus()

  modelDidChange: Ember.observer 'model', ->
    Ember.run.next =>
      @initialise()

  form: null

  contactName: ""
  companyName: ""
  contactEmail: ""
