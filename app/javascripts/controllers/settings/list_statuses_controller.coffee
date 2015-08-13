Radium.SettingsListStatusesController = Radium.Controller.extend
  actions:
    editList: (list) ->
      @set 'currentList', list
      Ember.run.next =>
        @set 'showListModal', true

      false

    closeListModal: ->
      @set 'showListModal', false

      false

  showListModal: false
  currentList: null
