Radium.CurrencyPickerComponent = Ember.Component.extend
  actions:
    changeCurrency: (currency) ->
      account = @get('currentUser.account')

      account.set 'currency', currency.key

      targetObject = @get('targetObject')

      account.save(targetObject).then (result) ->
        targetObject.send 'flashSuccess', 'The currency has been changed.'

  classNameBindings: [":currency-picker"]

  currencies: Radium.Currencies

  currentCurrency: Ember.computed 'currentUser.account.currency', ->
    Radium.Currencies.find (c) => c.key == @get('currentUser.account.currency')