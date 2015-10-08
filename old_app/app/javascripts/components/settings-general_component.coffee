Radium.SettingsGeneralComponent = Ember.Component.extend
  actions:
    deleteExcludedDomain: (domain) ->
      @sendAction "deleteExcludedDomain", domain

      false

    switchShareInbox: ->
      return if @get('isSaving')

      Ember.run.next =>
        @set 'isSaving', true

        currentUser = @get('currentUser')

        currentUser.set 'shareInbox', @get('inboxIsShared')

        unless currentUser.get('isDirty')
          return @set 'isSaving', false

        currentUser.save().then((result) =>
          @set 'isSaving', false
        ).catch (error) =>
          Ember.Logger.error(error)
          @set 'isSaving', false

      false

    changeCurrency: (currency) ->
      account = @get('currentUser.account')

      account.set 'currency', currency.key

      targetObject = @get('targetObject')

      account.save().then (result) ->
        targetObject.send 'flashSuccess', 'The currency has been changed.'

  currentCurrency: Ember.computed 'currentUser.account.currency', ->
    Radium.Currencies.find (c) => c.key == @get('currentUser.account.currency')

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @set 'inboxIsShared', @get('currentUser.shareInbox')

  inboxIsShared: false

  isSaving: false
