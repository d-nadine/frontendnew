Radium.ChangeListstatusComponent = Ember.Component.extend
  actions:
    closeInactiveReasonModal: ->
      @set "showInactiveReasonModal", false
      @set "changeStatus", null
      @set "inactiveReason", null

      false

    changeListStatus: (listStatus)->
      return if listStatus == @get('currentListStatus')

      unless listStatus.get('isActive')
        @set "changeStatus", listStatus
        @set "showInactiveReasonModal", true
        @focusInactiveTextbox()

        return false

      @createChangeStatus(listStatus)

      false

    createInactiveStatusChange: ->
      if Ember.isEmpty(@inactiveReason)
        @focusInactiveTextbox()
        return @flashMessenger.error "You must supply a reason why you are changing to this status."

      @createChangeStatus(@changeStatus)

      false

  createChangeStatus: (listStatus) ->
    return if listStatus == @get('currentListStatus')

    deal = @get('deal')

    deal.updateLocalBelongsTo('currentStatus', listStatus)

    statusChange = Radium.CreateDealStatusTransition.createRecord
                     deal: deal
                     listStatus: listStatus
                     inactiveReason: @inactiveReason

    deal.updateLocalProperty('statusLastChangedAt', Ember.DateTime.create())
    statusChange.save()

  focusInactiveTextbox: ->
    Radium.Common.wait (@$('textarea').length > 0), -> @$('textarea').focus()

  currentListStatus: Ember.computed 'deal', ->
    deal = @get('deal')

    return unless deal.get('isLoaded')

    deal.get('currentStatus')

  remainingStatuses: Ember.computed 'deal.list.listStatuses.[]', 'currentListStatus', ->
    listStatuses = @get('deal.list.listStatuses')?.toArray()

    return unless (listStatuses && listStatuses.get('length')) && currentStatus = @get('currentListStatus')

    listStatuses.reject((status) -> status == currentStatus
    ).sort (a, b) ->
      Ember.compare a.get('position'), b.get('position')

  showInactiveReasonModal: false
  changeStatus: null
  inactiveReason: null
