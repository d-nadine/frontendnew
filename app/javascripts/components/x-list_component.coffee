Radium.XListComponent = Ember.Component.extend
  actions:
    showNewDealModal: ->
      @set "showDealModal", true

      false

    closeDealModal: ->
      @set "deal", null

      @set "showDealModal", false

      false

  classNames: ['single-column-container']

  filterStartDate: null
  filterEndDate: null

  showDealModal: false
  deal: null
