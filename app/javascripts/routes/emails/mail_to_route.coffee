Radium.EmailsMailToRoute = Ember.Route.extend
  serialize: (model) ->
    key = model.humanize().pluralize()

    recipient_type: key
    recipient_id: model.get('id')

  model: (params) ->
    type = Radium.get(params.recipient_type.singularize().capitalize())

    Em.assert "Type not found from recipient_type #{params.recipient_type} in EmailsMailToRoute", type

    type.find(params.recipient_id)

  afterModel: (model, transition)->
    newEmailcontroller = @controllerFor('emailsNew')
    newEmailcontroller.set 'showAddresses', true
    form = newEmailcontroller.get('newEmail')
    form.reset()
    form.set 'showAddresses', true
    form.set 'showSubject', true
    form.get('to').pushObject(model)
    sidebarController = @controllerFor('messagesSidebar')
    sidebarController.send 'reset'
    @transitionTo 'emails.new', sidebarController.get('folder'), queryParams: bulkEmail: false
