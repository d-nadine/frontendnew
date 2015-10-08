Radium.ListstatusPickerComponent = Ember.Component.extend
  actions:
    changeListStatus: (status) ->
      @sendAction "changeStatus", status

      false

  currentStatusName: Ember.computed 'currentStatus', ->
    unless currentStatus = @get('currentStatus')
      return @get('noItemText') || "Choose Status"

    currentStatus.get('name')

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
