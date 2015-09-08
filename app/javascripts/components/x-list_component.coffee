require 'components/deal_columns_config'

Radium.XListComponent = Ember.Component.extend Radium.DealColumnsConfig,
  actions:
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

  closeDrawer: ->
    @set 'showDrawer', false
    @set 'drawerModel', null
    @set 'drawerParams', null
