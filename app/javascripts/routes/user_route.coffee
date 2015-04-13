Radium.UserRoute = Radium.Route.extend
  actions:
    confirmDeletion: ->
      @render 'user/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: ->
      user = @modelFor 'user'

      name = user.get('name')

      user.save(this).then =>
        @send 'flashSuccess', "User #{name} has been deleted"
        @transitionTo 'settings.company'

      @send 'closeModal'

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
