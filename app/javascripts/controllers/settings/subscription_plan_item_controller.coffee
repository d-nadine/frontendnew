Radium.SubscriptionPlanItemController = Radium.ObjectController.extend
  hasToken: Ember.computed.alias 'parentController.hasToken'
  notSelectable: ( ->
    !@get('hasToken')
  ).property('hasToken')
