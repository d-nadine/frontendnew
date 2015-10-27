Radium.XDealComponent = Ember.Component.extend Radium.AttachedFilesMixin,
  actions:
    showCompanyModal: (company) ->
      @sendAction "showCompanyModal", company

      false

    showContactModal: (contact) ->
      @sendAction "showContactModal", contact

      false

    showContactDrawer: (contact) ->
      @sendAction "showContactDrawer", contact

      false

    showCompanyDrawer: (company) ->
      @sendAction "showCompanyDrawer", company

    deleteDeal: (deal) ->
      if deals = @get('targetObject.deals')
        deals.removeObject(deal)

      @EventBus.publish 'closeListDrawers'

      deal.delete().then =>
        @flashMessenger.success "Deal deleted!"

      false

  model: Ember.computed.oneWay 'deal'

  classNames: ['two-column-layout']

  showDeleteConfirmation: false
