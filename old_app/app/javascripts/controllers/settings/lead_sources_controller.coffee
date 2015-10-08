Radium.SettingsLeadSourcesController = Radium.ArrayController.extend
  actions:
    createLeadSource: ->
      @get('leadSources').pushObject Ember.Object.create name: "New", isNew: true

    saveSources: ->
      account = @get('account')

      account.set('leadSources', @get('leadSources').map (source) -> source.get('name'))

      return unless account.get('isDirty')

      @send 'commit'

    commit: ->
      account = @get('account')

      account.save().then((result) =>
        @send 'flashSuccess', 'Updated'
        @set 'isSaving', false
      ).catch (result) ->
        @set 'isSaving', false

    deleteLeadSource: (item) ->
      account = @get('account')

      if item.get('isNew')
        return @get('leadSources').removeObject item

      if account.get('leadSources.length') <= 2
        @send 'flashError', 'You must have at least 2 lead sources'
        return

      remainingSources = @get('leadSources').reject((source) ->
                                                      source.get('name') == item.get('name'))
                                            .map (source) -> source.get('name')

      account.set('leadSources', remainingSources)

      @send 'commit'

  cancelModel: (item) ->
    @get('leadSources').removeObject item

  needs: ['account']
  account: Ember.computed.alias 'controllers.account.model'

  leadSources: Ember.computed 'account.leadSources.[]', ->
    @get('account.leadSources').map (source) -> Ember.Object.create name: source
