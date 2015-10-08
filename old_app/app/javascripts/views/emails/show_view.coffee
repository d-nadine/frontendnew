Radium.EmailsShowView = Radium.View.extend Radium.ScrollTopMixin,
  Radium.ContentIdentificationMixin,

  actions:
    showExtension: ->
      document.getElementById('show-extension').click()
      @get('controller').send 'dismissExtension'

  classNameBindings: ['itemType']
  templateName: Ember.computed 'controller.model', ->
    return unless model = @get("controller.model")

    path = model.humanize().pluralize()

    "#{path}/show"

  itemType: Ember.computed 'controller.model', ->
    return unless model = @get("controller.model")

    model.humanize().pluralize()
