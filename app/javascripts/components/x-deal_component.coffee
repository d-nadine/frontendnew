Radium.XDealComponent = Ember.Component.extend Radium.AttachedFilesMixin,
  actions:
    deleteDeal: (deal) ->
      p "in delete"

      @EventBus.publish 'closeDrawers'

      false

  model: Ember.computed.oneWay 'deal'

  classNames: ['two-column-layout']

  showDeleteConfirmation: false
