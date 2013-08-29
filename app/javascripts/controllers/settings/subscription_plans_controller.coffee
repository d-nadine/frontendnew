Radium.SubscriptionPlansController = Radium.ArrayController.extend
  currentSubscription: Ember.computed.alias 'parentController.subscription'
  isCurrent: ( ->
    if currentSubscription = @get('currentSubscription')
      @get('model.name') == currentSubscription
  ).property('model', 'currentSubscription')
