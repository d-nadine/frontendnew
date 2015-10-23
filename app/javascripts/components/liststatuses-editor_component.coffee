require "mixins/common_modals"

Radium.ListstatusesEditorComponent = Ember.Component.extend Radium.CommonModals,
  actions:
    setInitialStatus: (initialStatus) ->
      @set 'initialStatus', initialStatus

      actionListStatus = @get('actionListStatus')
      listAction = @get('listAction')
      actionList = @get('actionList')

      list = @get('list')

      list.setProperties
        actionListStatus: actionListStatus
        listAction: listAction
        actionList: actionList
        initialStatus: initialStatus

      list.save()

      false

    setActionList: (list) ->
      unless list.constructor is Radium.List
        Ember.assert "You must include the Radium.CommonModals mixin to create a new list", @_actions['createList']

        return @send 'createList', list, @setActionList.bind(this)

      @setActionList list

      false

    removeActionList: (listStatus) ->
      @setProperties
        actionListStatus: null
        listAction: null
        actionList: null
        initialStatus: null

      list = @get('list')

      list.setProperties
        actionListStatus: null
        listAction: null
        actionList: null
        initialStatus: null

      list.save()

      false

    setActionListStatus: (listStatus) ->
      @set 'actionListStatus', listStatus

      false

    setMoveAction: (action) ->
      @$('.move-action').removeClass "open"

      @set "listAction", action

      Ember.run.next =>
        @$('.autocomplete input[type=text]').focus()

      false

    moveListStatus: (listStatus, direction) ->
      return if @get('isSaving')

      currentPosition = listStatus.get('position')

      nextPosition = if direction == "up"
                       currentPosition - 1
                     else
                       currentPosition + 1

      if nextPosition < 1 || nextPosition > @get('listStatuses.length')
        return

      @set 'isSaving', true

      current = @get('listStatuses').find (l) -> l.get('position') == nextPosition

      current.updateLocalProperty "position", currentPosition

      listStatus.updateLocalProperty "position", nextPosition

      Ember.run.next =>
        @notifyPropertyChange "sortedListStatuses"

      move = Radium.MoveListStatus.createRecord
               direction: direction
               listStatus: listStatus

      move.save().finally =>
        @set "isSaving", false

      false

    createNewStatus: ->
      name = @get('newStatus.name') || ''

      unless name.length
        @$().find('.new-list-status-name').focus()
        return @flashMessenger.error "you must supply a name."

      statusType = if @get('newStatus.isActive')
                     "active"
                   else
                     "inactive"

      record = Radium.ListStatus.createRecord
                  name: name
                  statusType: statusType
                  list: @get('list')

      record.save().then =>
        @flashMessenger.success "List Status Created"
        @send "closeListStatusModal"

      false

    addNewListStatus: ->
      @set "newStatus", Ember.Object.create
                          name: null
                          isActive: true

      @set "showListStatusModal", true

      Ember.run.next =>
        return unless el = @$()

        el.find('.new-list-status-name').focus()

      false

    closeListStatusModal: ->
      @set "newStatus", null

      @set "showListStatusModal", false

      false

  setActionList: (list) ->
    @set 'actionList', list

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    list = @get('list')

    @set 'actionList', list.get('actionList')
    @set 'listAction', list.get('listAction')

    @set 'actionListStatus', list.get('actionListStatus')

    @set 'initialStatus', list.get('initialStatus')

    @set 'listActions', Ember.A([@get('listAction')]).compact()

  listActionText: Ember.computed "listAction", ->
    unless listAction = @get("listAction")
      return "Choose Action"

    "#{@get('listAction').capitalize()} To"

  showListSelector: Ember.computed 'listAction', 'actionList', ->
    not Ember.isEmpty(@get('listAction')) && not @get('actionList')

  sortedListStatuses: Ember.computed 'listStatuses.@each.position', (a, b) ->
    @get('listStatuses').toArray().sort (a, b) ->
      Ember.compare a.get('position'), b.get('position')

  lists: Ember.computed.oneWay 'listsService.sortedLists'

  remainingLists: Ember.computed 'lists.[]', 'list', ->
    @get('lists').reject (l) => l == @get('list')

  isSaving: false

  newStatus: null
  tagName: 'ul'
  classNames: ['span7']
  newStatusNameValidations: ['required']
  errorMessages: []
