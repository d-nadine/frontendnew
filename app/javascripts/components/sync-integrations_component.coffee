require "mixins/lists_persistence_mixin"
require 'mixins/user_combobox_props'
require "mixins/common_modals"

Radium.ThirdpartyIntegrationMap =
  intercom:
    keys: {
      'app_id': ''
      'api_key': ''
    }

Radium.SyncIntegrationsComponent = Ember.Component.extend Radium.ListsPersistenceMixin,
  Radium.CommonModals,
  actions:
    addList: (list) ->
      model = if integration = @getIntegration('intercom')
                integration
              else
                Ember.Object.create(lists: @get('integrationLists').slice(), isNew: true)

      unless list.constructor is Radium.List
        Ember.assert "You must include the Radium.CommonModals mixin to create a new list", @_actions['createList']

        return @send 'createList', list, model

      @get('integrationLists').pushObject(list)

      return false if @get('isNew')

      @_super model, list

      false

    removeList: (list) ->
      model = if integration = @getIntegration('intercom')
                integration
              else
                Ember.Object.create(lists: @get('integrationLists').slice(), isNew: true)

      @get('integrationLists').removeObject(list)

      return false if model.get('isNew')

      @_super model, list

      false

    disconnect: (integration) ->
      unless confirm("Are you sure you want to disconnect the #{integration} connection?")
        return

      existing = @getIntegration(integration)

      @set 'isDeleting', true

      existing.delete().then =>
        @get('integrations').removeObject integration

        @notifyPropertyChange 'intercomSet'

        @send "hideIntegration", integration

        @set 'isDeleting', false

      false

    updateIntegration: (type) ->
      @set 'isUpdating', true

      existing = @getIntegration(type)

      inputs = @inputs(type)

      invalid = inputs.filter (i, input) ->
        val = $(input).val() || ''

        !!!$.trim(val).length

      if invalid.length
        invalid[0].focus()
        return @flashMessenger.error("Please supply all configuration fields.")

      integration = if existing then existing else Radium.ThirdpartyIntegration.createRecord()

      configuration = $.extend({}, Radium.ThirdpartyIntegrationMap[type].keys)

      Ember.keys(configuration).forEach (key) ->
        configuration[key] = @$(".integration-config.#{type} input[type=text].#{key}").val()

      integration.setProperties(name: type, config: configuration)

      if integration.get('isNew')
        integration.set('newLists', @get('integrationLists').mapProperty('id'))

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

  getIntegration: (type) ->
    Radium.ThirdpartyIntegration.all().find (i) -> i.get('name') == type

  showHideIntegration: (integration, action) ->
    method = "show#{integration.capitalize()}Config"
    show = (action == "show")

    @set method, show

  inputs: (integration) ->
    @$(".integration-config.#{integration} input[type=text]").not('.as-input')

  isUpdatingIntercom: false

  intercomSet: Ember.computed 'integrations.[]', 'isUpdatingIntercom', ->
    return false if @get('isUpdatingIntercom')

    @hasIntegration('intercom')

  hasIntegration: (type) ->
    @get('integrations').contains(type)

  lists: Ember.computed.oneWay 'listsService.sortedLists'

  didInsertElement: ->
    @_super.apply this, arguments

    if integration = @getIntegration('intercom')
      @set 'integrationLists', integration.get('lists').slice()
    else
      @set 'integrationLists', Ember.A()
