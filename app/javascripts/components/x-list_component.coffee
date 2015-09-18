require 'components/deal_columns_config'

Radium.XListComponent = Ember.Component.extend Radium.DealColumnsConfig,
  actions:
    loadMoreDeals: ->
      deals = @get('deals')

      observer = ->
        return if deals.get('isLoading')
        deals.removeObserver 'isLoading', observer
        deals.expand()

      unless deals.get('isLoading')
        observer()
      else
        deals.addObserver 'isLoading', observer

      false

    saveDealValue: (deal, value) ->
      deal.set 'value', value

      deal.save()

      false

    showNewDealModal: ->
      @set "showDealModal", true

      false

    closeDealModal: ->
      @set "deal", null

      @set "showDealModal", false

      false

    closeListDrawer: ->
      @closeDrawer()

      false

    showDealDrawer: (deal) ->
      @closeDrawer()

      @set 'drawerModel', deal

      config = {
        bindings: [{
          name: "deal",
          value: "drawerModel"
        },
        {
          name: "lists",
          value: "lists"
        }
        {
          name: "closeDrawer",
          value: "closeListDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        }
        ]
        component: 'x-deal'
      }

      @set 'drawerParams', config

      @set 'showDrawer', true

      false

  combinedColumns: Ember.computed 'columns.[]', ->
    @get('columns')

  classNames: ['single-column-container']

  filterStartDate: null
  filterEndDate: null

  showDealModal: false
  deal: null
  showDrawer: false
  drawerModel: null
  drawerParams: null

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @EventBus.subscribe "closeDrawers", this, @closeDrawer.bind(this)

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    @send 'loadMoreDeals'

  closeDrawer: ->
    @set 'showDrawer', false
    @set 'drawerModel', null
    @set 'drawerParams', null
