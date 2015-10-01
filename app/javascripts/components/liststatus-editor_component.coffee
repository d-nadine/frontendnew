require "mixins/common_modals"

Radium.ListstatusEditorComponent = Ember.Component.extend Radium.CommonModals,

  actions:
    addList: (list) ->
      unless list.constructor is Radium.List
        Ember.assert "You must include the Radium.CommonModals mixin to create a new list", @_actions['createList']

        return @send 'createList', list, @setListAction.bind(this)

      false

    removeList: (list) ->
      @get('actions').removeObject(list)

      @set 'listAction', null

      # record = Radium.RemoveListActon.createRecord
      #            listStatus: @get('listStatus')

      # record.save()

      false

    moveListStatus: (listStatus, direction) ->
      @sendAction "moveListStatus", listStatus, direction

      false

    setMoveAction: (action) ->
      @set "listAction", action

      Ember.run.next =>
        @$('.autocomplete input[type=text]').focus()

      false

    switchStatus: ->
      return if @get('isSaving')

      @set "isSaving", true

      listStatus = @get('listStatus')

      Ember.run.next =>
        statusType = if @get('isActive')
                       "active"
                     else
                       "inactive"

        listStatus.set('statusType', statusType)

        listStatus.save()

      false

    deleteListStatus: (listStatus) ->
      name = listStatus.get('name')
      list = listStatus.get('list')

      if list.get('listStatuses.length') <= 2
        return @flashMessenger.error "You must have at least 2 list statuses."

      listStatus.delete().then( =>
        @flashMessenger.success "List Status #{name} has been deleted."
      ).catch ->
        list.reload()

      false

  setListAction: (list) ->
    listStatus = @get('listStatus')
    action = @get('listAction')

    # record = Radium.AddListAction
    #            listStatus: listStatus
    #            list: list
    #            action: listAction

    # record.save()

    @get('actions').pushObject(list)

  tagName: 'li'

  isActive: null
  isSaving: false

  listActionText: Ember.computed "hasListAction", ->
    unless listAction = @get("listAction")
      return "On Status Change"

    @get('listAction').capitalize()

  listActions: Ember.computed 'listAction', 'actionList', ->
    not Ember.isEmpty(@get('listAction'))

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    listStatus = @get('listStatus')

    @set 'isActive', @get('listStatus.isActive')
    @set 'actionList', listStatus.get('actionList')

  # UPGRADE: replace with inject
  lists: Ember.computed ->
    @container.lookup('controller:lists').get('sortedLists')

