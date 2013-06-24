Radium.SettingsBillingController = Ember.ArrayController.extend
  needs: 'users'
  isNewCard: false

  changeBilling: ->
    @set('isNewCard', true)

  cancel: ->
    @set('isNewCard', false)

  currentPlan: (->
    @get('content').findProperty('isCurrent', true)
  ).property('@each.isCurrent')

  updateBilling: ->
    @set('isUpdatingBilling', true)

    Ember.run.later(=>
      @setProperties
        isUpdatingBilling: false
        isNewCard: false
    , 1500)

  upgradePlan: (model) ->
    @get('content').setEach('isCurrent', false)
    model.set('isCurrent', true)