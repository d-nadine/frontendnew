Radium.UserRoute = Radium.Route.extend
  actions:
    deleteRecord: ->
      user = @modelFor 'user'

      name = user.get('name')

      user.delete().then =>
        @send 'flashSuccess', "User #{name} has been deleted"
        @transitionTo 'settings.company'

      @send 'closeModal'

  setupController: (controller, model) ->
    ['todo', 'meeting'].forEach (form) ->
      if form = controller.get("formBox.#{form}Form")
        form?.reset()

    controller.set('model', model)

  renderTemplate: ->
    @render()
    @render 'user/sidebar',
      into: 'user'
      outlet: 'sidebar'

  deactivate: ->
    model = @controller.get('model')

    return unless model.get('inCleanState')

    model.reload()

Radium.UserFormRoute = Radium.Route.extend
  model: (params) ->
    params.form

  setupController: (controller, form) ->
    @controllerFor('user').set('activeForm', form)
