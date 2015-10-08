Radium.SettingsMailComponent = Ember.Component.extend
  actions:
    setAlias: ->
      alias = @get('alias') || ''

      return unless alias.length

      return if @get('isSaving')

      @set 'isSaving', true

      @set('currentUser.settings.emailAlias', alias)

      @get('currentUser.settings').save().then(=>
        @flashMessenger.success "Alias Updated"
      ).finally =>
        @set('isSaving', false)

      false

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

    @set('alias', @get('currentUser.settings.emailAlias')) || ''
