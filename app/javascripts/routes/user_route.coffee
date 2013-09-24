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

      user.deleteRecord()

      @render 'nothing',
        into: 'application'
        outlet: 'modal'

      @render 'user/deleted',
        into: 'application'

  renderTemplate: ->
    @render()
    @render 'user/sidebar',
      into: 'user'
      outlet: 'sidebar'

Radium.UserFormRoute = Radium.Route.extend
  model: (params) ->
    params.form

  setupController: (controller, form) ->
    @controllerFor('user').set('activeForm', form)
