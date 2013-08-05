Radium.EmailsMailToRoute = Ember.Route.extend
  serialize: (model) ->
    key = Radium.Model.keyFromValue(model.constructor)

    unless key
      throw new Error("no entry in Radium.Model.mappings for #{model.constructor}")

    recipient_type: key
    recipient_id: model.get('id')

  model: (params) ->
    type = Radium.Model.mappings[params.recipient_type]

    type.find(params.recipient_id)

  afterModel: (model, transition)->
    newEmailcontroller = @controllerFor('emailsNew')
    newEmailcontroller.set 'showAddresses', true
    form = newEmailcontroller.get('newEmail')
    form.reset()
    form.set 'showAddresses', true
    form.set 'showSubject', true
    form.get('to').pushObject(model)
    @transitionTo 'emails.new'
