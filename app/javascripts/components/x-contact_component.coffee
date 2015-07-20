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

  classNames: ['two-column-layout']

  model: Ember.computed.oneWay 'contact'
