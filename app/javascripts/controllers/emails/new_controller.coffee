Radium.EmailsNewController = Radium.Controller.extend Ember.Evented,
  actions:
    addSignature: (signature) ->
      @set 'settings.signature', signature

      @get('settings').save(this).then =>
        @send 'flashSuccess', 'Signature updated'

    changeViewMode: (mode) ->
      @transitionToRoute "emails.new", queryParams: mode: mode

      false

  queryParams: ['mode']

  isBulkEmail: Ember.computed.equal 'mode', "bulk"

  needs: ['userSettings']

  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'
