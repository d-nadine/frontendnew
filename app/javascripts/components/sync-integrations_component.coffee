Radium.ThirdpartyIntegrationMap =
  intercom:
    keys: {
      'app_id': ''
      'api_key': ''
    }

Radium.SyncIntegrationsComponent = Ember.Component.extend
  actions:
    disconnect: (integration) ->
      unless confirm("Are you sure you want to disconnect the #{integration} connection?")
        return

      existing = Radium.ThirdpartyIntegration.all().find (i) -> i.get('name') == integration

      @set 'isDeleting', true

      existing.delete().then =>
        @get('integrations').removeObject integration

        @notifyPropertyChange 'intercomSet'

        @send "hideIntegration", integration

        @set 'isDeleting', false

      false

    updateIntegration: (type) ->
      @set 'isUpdating', true

      existing = Radium.ThirdpartyIntegration.all().find (i) -> i.get('name') == type

      inputs = @inputs(type)

      invalid = inputs.filter (i, input) ->
        val = $(input).val() || ''

        !$.trim(val).length

      if invalid.length
        invalid[0].focus()
        return @flashMessenger.error("Please supply all configuration fields.")

      integration = if existing then existing else Radium.ThirdpartyIntegration.createRecord()

      configuration = $.extend({}, Radium.ThirdpartyIntegrationMap[type].keys)

      Ember.keys(configuration).forEach (key) ->
        configuration[key] = @$(".integration-config.#{type} input[type=text].#{key}").val()

      integration.setProperties(name: type, config: configuration)

      integration.save().then (integration) =>
        @flashMessenger.success "Integration configuration set!"
        unless @get('integrations').contains(type)
          @get('integrations').push(type)

        @set "isUpdating#{type.capitalize()}", false
        @notifyPropertyChange('intercomSet')

      false

    update: (type) ->
      @set "isUpdating#{type.capitalize()}", true

    showIntegration: (integration) ->
      @showHideIntegration(integration, "show")

      Ember.run.next =>
        @inputs(integration).first().focus()

      false

    hideIntegration: (integration) ->
      prop = "isUpdating#{integration.capitalize()}"

      if @get(prop)
        return @set prop, false

      @showHideIntegration(integration, "hide")

      @inputs(integration).val('')

      false

  showHideIntegration: (integration, action) ->
    method = "show#{integration.capitalize()}Config"
    show = (action == "show")

    @set method, show

  inputs: (integration) ->
    @$(".integration-config.#{integration} input[type=text]")

  isUpdatingIntercom: false

  intercomSet: Ember.computed 'integrations.[]', 'isUpdatingIntercom', ->
    return false if @get('isUpdatingIntercom')

    @hasIntegration('intercom')

  hasIntegration: (type) ->
    @get('integrations').contains(type)
