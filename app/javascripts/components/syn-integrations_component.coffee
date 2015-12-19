Radium.SyncIntegrationsComponent = Ember.Component.extend
  actions:
    showIntegration: (integration) ->
      @showHideIntegration(integration, "show")

      Ember.run.next =>
        @$('.integration-config input[type=text]:first').focus()

      false

    hideIntegration: (integration) ->
      @showHideIntegration(integration, "hide")

      @$('.integration-config input[type=text]').val('')

      false

  showHideIntegration: (integration, action) ->
    method = "show#{integration.capitalize()}Config"
    show = (action == "show")

    @set method, show
