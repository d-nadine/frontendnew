Radium.SettingsMailComponent = Ember.Component.extend
  actions:
    setOpenTracking: ->
      return false if @get('isSaving')

      Ember.run.next =>
        @set 'isSaving', true

  isSaving: false

  settings: Ember.computed.oneWay 'currentUser.settings'

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    settings = @get('settings')

    p settings

    @set 'enableOpenTracking', settings.get('enableOpenTracking')
    @set 'enableClickTracking', settings.get('enableClickTracking')
