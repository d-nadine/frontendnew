Radium.ReportDropdownComponent = Ember.Component.extend
  classNames: 'btn-group'
  actions:
    selectFilter: (filter) ->
      @sendAction 'action', filter