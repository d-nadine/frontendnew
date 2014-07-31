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

      user.deleteRecord()

      user.one 'didDelete', =>
        @send 'flashSuccess', "User #{name} has been deleted"

      user.one 'becameInvalid', (result) ->
        result.reset()

      user.one 'becameError', (result) ->
        result.reset()

      @send 'closeModal'
      @transitionTo 'settings.company'

      @get('store').commit()

  renderTemplate: ->
    @render()
    @render 'user/sidebar',
      into: 'user'
      outlet: 'sidebar'

  setupController: (controller, model) ->
    ['todo', 'call', 'meeting'].forEach (form) ->
      if form = controller.get("formBox.#{form}Form")
        form?.reset()

    controller.set('model', model)

  deactivate: ->
    @controller.get('model').reload()

Radium.UserFormRoute = Radium.Route.extend
  model: (params) ->
    params.form

  setupController: (controller, form) ->
    @controllerFor('user').set('activeForm', form)
