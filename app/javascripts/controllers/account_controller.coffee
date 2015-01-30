Radium.AccountController = Radium.ObjectController.extend
  hasGatewayAccount: Ember.computed 'billing.gatewayIdentifier', ->
    return @get('billing.gatewayIdentifier')

  accountCurrency: Ember.computed 'currency', ->
    Radium.Currencies.find (c) => c.key == @get('currency')

  currencyDidChange: Ember.observer 'currency', ->
    Ember.assert 'Account currency has been set', @get('currency')

    currency = @get('accountCurrency')

    Ember.assert "Found account currenct", currency

    accounting.settings = {
      currency: {
      symbol : currency.symbol,
      format: "%s %v",
      decimal : currency.decimal,
      thousand: currency.thousand,
      precision : 2
      },
      number: {
        precision : 0,
        thousand: currency.thousand,
        decimal : currency.decimal
      }
    }
