Radium.LeadsNewComponent = Ember.Component.extend
  actions:
    modelChanged: (model) ->
      @sendAction 'modelChanged', model

  classNameBindings: [':form', ':new-lead-form']

  setup: Ember.on 'didInsertElement', ->
    Ember.run.scheduleOnce 'afterRender', this, 'initialise'

  initialise: ->
    @$('.contact-name input[type=text]').focus()

  form: null
