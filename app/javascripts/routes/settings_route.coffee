Radium.SettingsRoute = Radium.Route.extend
  model: ->
    Radium.Settings.find(1)

  events:
    flashMessage: (options) ->
      controller = @controllerFor 'settingsFlash'
      controller.setProperties
        type: options.type ? null
        message: options.message ? "Settings saved!"

      @render('settingsFlash',
        outlet: 'flash'
        into: 'settings'
        controller: controller
      )

Radium.SettingsIndexRoute = Radium.Route.extend
  redirect: ->
    @.transitionTo 'settings.profile'