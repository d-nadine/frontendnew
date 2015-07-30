Radium.SettingsMailComponent = Ember.Component.extend
  actions:
    setOpenTracking: ->
      @setMailFlag('enableOpenTracking')

      false

    setClickTracking: ->
      @setMailFlag('enableClickTracking')

      false

  setMailFlag: (prop) ->
    return false if @get('isSaving')

    Ember.run.next =>
      @set 'isSaving', true

      settings = @get('settings')

      settings.set prop, @get(prop)

      settings.save()
      .then().finally =>
        @set "isSaving", false

  isSaving: false

  settings: Ember.computed.oneWay 'currentUser.settings'

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    settings = @get('settings')

    @set 'enableOpenTracking', settings.get('enableOpenTracking')
    @set 'enableClickTracking', settings.get('enableClickTracking')
