Radium.EmailsNewController = Radium.Controller.extend Ember.Evented,
  actions:
    addSignature: (signature) ->
      @set 'settings.signature', signature

      @get('settings').save(this).then =>
        @send 'flashSuccess', 'Signature updated'


  newEmail: Radium.EmailForm.create()

  queryParams: ['bulkEmail']

  isBulkEmail: Ember.computed.equal 'bulkEmail', "true"

  bulkEmail: null

  needs: ['userSettings']

  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'
