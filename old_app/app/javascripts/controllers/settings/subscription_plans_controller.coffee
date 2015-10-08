Radium.SubscriptionPlansController = Radium.ArrayController.extend
  currentSubscription: Ember.computed.alias 'parentController.subscriptionPlan'
  isCurrent: Ember.computed 'model', 'currentSubscription', ->
    if currentSubscription = @get('currentSubscription')
      @get('model.name') == currentSubscription
