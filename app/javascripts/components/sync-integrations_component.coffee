Radium.IntegrationMap =
  intercom:
    keys: {
      'app_id': ''
      'api_key': ''
    }

Radium.SyncIntegrationsComponent = Ember.Component.extend
  actions:
    updateIntegration: (type) ->
      existing = Radium.Integration.all().find (i) -> i.get('type') == integration

      inputs = @inputs(type)

      invalid = inputs.filter (i, input) ->
        val = $(input).val() || ''

        !$.trim(val).length

      if invalid.length
        invalid[0].focus()
        return @flashMessenger.error("Please supply all configuration fields.")

      integration = if existing then existing else Radium.Integration.createRecord()

      configuration = $.extend({}, Radium.IntegrationMap[type].keys)

      Ember.keys(configuration).forEach (key) ->
        configuration[key] = @$(".integration-config.#{type} input[type=text].#{key}").val()

      integration.setProperties(name: type, config: configuration)

      integration.save().then (integration) ->
        p "saved"

      false

    showIntegration: (integration) ->
      @showHideIntegration(integration, "show")

      Ember.run.next =>
        @inputs(integration).first().focus()

      false

    hideIntegration: (integration) ->
      @showHideIntegration(integration, "hide")

      @inputs(integration).val('')

      false

  showHideIntegration: (integration, action) ->
    method = "show#{integration.capitalize()}Config"
    show = (action == "show")

    @set method, show

  inputs: (integration) ->
    @$(".integration-config.#{integration} input[type=text]")
