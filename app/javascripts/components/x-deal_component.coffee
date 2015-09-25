Radium.XDealComponent = Ember.Component.extend Radium.AttachedFilesMixin,
  actions:
    showContactDrawer: (contact) ->
      @sendAction "showContactDrawer", contact, true

      false

    showCompanyDrawer: (company) ->
      @sendAction "showCompanyDrawer", company, true

    deleteDeal: (deal) ->
      p "in delete"

      @EventBus.publish 'closeDrawers'

      false

  model: Ember.computed.oneWay 'deal'

  classNames: ['two-column-layout']

  showDeleteConfirmation: false
