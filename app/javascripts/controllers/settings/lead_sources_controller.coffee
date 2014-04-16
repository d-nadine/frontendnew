Radium.SettingsLeadSourcesController = Radium.ArrayController.extend
  actions:
    createLeadSource: ->
      @get('account.leadSources').pushObject "New Lead Source #{@get('account.leadSources.length') + 1}"
      @send 'saveSources'

    saveSources: ->
      account = @get('account')

      return if @get('account.isSaving')

      account.set('leadSources', @get('leadSources').map (source) -> source.get('name'))

      return unless account.get('isDirty')

      @send 'commit'

    commit: ->
      account = @get('account')

      account.one 'didUpdate', =>
        @send 'flashSuccess', 'Updated'

      account.one 'becameInvalid', (result) =>
        @send 'flashError', result
        account.reset()

      account.one 'becameError', (result) =>
        @send 'flashError', 'An error occurred and the action can not be completed'
        result.reset()

      @get('store').commit()

    deleteLeadSource: (item) ->
      account = @get('account')

      if account.get('leadSources.length') <= 2
        @send 'flashError', 'You must have at least 2 lead sources'
        return

      return if @get('account.isSaving')

      remainingSources = @get('leadSources').reject((source) -> 
                                                      source.get('name') == item.get('name'))
                                            .map (source) -> source.get('name')

      account.set('leadSources', remainingSources)

      @send 'commit'

  needs: ['account']
  account: Ember.computed.alias 'controllers.account.model'

  leadSources: ( ->
    @get('account.leadSources').map (source) -> Ember.Object.create name: source
  ).property('account.leadSources.[]') 
