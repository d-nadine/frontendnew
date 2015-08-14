Radium.SettingsListStatusesController = Radium.Controller.extend
  actions:
    deleteList: ->
      list = @get('currentList')

      list.delete().then =>
        @flashMessenger.success "List Deleted."

      false

    confirmDeleteList: (list) ->
      @set "currentList", list
      @set "showDeleteListConfirmation", true

      false

    showListModal: (list) ->
      @send 'closeListModal'

      unless list
        currentList = Ember.Object.create
                 isNew: true
                 name: ''
                 itemName: ''
                 type: 'contacts'
      else
        currentList = Ember.Object.create list.shallowCopy()
        currentList.setProperties isNew: false, id: list.get('id')

      @set 'currentList', currentList
      Ember.run.next =>
        @set 'showListModal', true

      false

    closeListModal: ->
      @set 'currentList', null
      @set 'showListModal', false

      false

  showListModal: false
  currentList: null
  showDeleteListConfirmation: false
