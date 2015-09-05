require "mixins/controllers/attached_files_mixin"

Radium.XContactComponent = Ember.Component.extend Radium.AttachedFilesMixin,
  actions:
    addTag: (tag) ->
      @sendAction "addTag", @get('contact'), tag

      false

    removeTag: (tag) ->
      @sendAction "removeTag", @get('contact'), tag

      false

    confirmDeletion: ->
      @sendAction "confirmDeletion"

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
