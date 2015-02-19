Radium.LeadsSingleController = Radium.Controller.extend
  actions:
    modelChanged: (model) ->
      @get('model').reset()
      @set 'form', null
      @set 'model', model

    clearExisting: ->
      @get('model').reset()
      form = @get('contactForm')
      form.reset()

      @set 'model', form

    saveModel: ->
      @get('model').save(this)
