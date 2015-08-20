Radium.ListstatusesEditorComponent = Ember.Component.extend
  actions:
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

  sortedListStatuses: Ember.computed 'listStatuses.@each.position', (a, b) ->
    @get('listStatuses').toArray().sort (a, b) ->
      Ember.compare a.get('position'), b.get('position')

  isSaving: false

  newStatus: null
  tagName: 'ul'
  classNames: ['span5']
  newStatusNameValidations: ['required']
  errorMessages: []
