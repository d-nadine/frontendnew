require "mixins/controllers/attached_files_mixin"
require "mixins/common_modals"

Radium.XContactComponent = Ember.Component.extend Radium.AttachedFilesMixin,
  Radium.CommonModals,

  actions:
    deleteContact: (contact) ->
      @sendAction "deleteContact", contact

      @EventBus.publish 'closeDrawers'

      false

    startPolling: ->
      updateContactPoller = @get('updateContactPoller')
      updateContactPoller.set 'contact', @get('contact')
      updateContactPoller.startPolling()

  classNames: ['two-column-layout']

  model: Ember.computed.oneWay 'contact'

  initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'updateContactPoller', Radium.UpdateContactPoller.create()

    @send('startPolling') if @contact.get('isUpdating')

  showDeleteConfirmation: false
