Radium.SettingsBillingController = Ember.ObjectController.extend
  isNewCard: false

  changeBilling: ->
    @set('isNewCard', true)

  cancel: ->
    @set('isNewCard', false)