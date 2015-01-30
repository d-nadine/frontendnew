Radium.CurrencyInputComponent = Ember.TextField.extend
  actions:
    formatValue: ->
      accountCurrency = @get('accountCurrency')

      settings =
        precision: accountCurrency.precision
        thousand: accountCurrency.thousand
        decimal: accountCurrency.decimal

      val = accounting.formatNumber @get('value'), settings

      @set 'value', val

  type: "text"
  timeout: 1000

  accountCurrency: Ember.computed ->
    accountController = @get('container').lookup('controller:account')
    accountController.get('accountCurrency')

  timeoutReference: null

  keyDown: (e) ->
    if e.keyCode == 13
      return @sendAction 'submit'

    accountCurrency = @get('accountCurrency')

    if timeoutReference = @get('timeoutReference')
      clearTimeout(timeoutReference)

    timeoutReference = setTimeout =>
      @send('formatValue')
    , @get('timeout')

    @set 'timeoutReference', timeoutReference

  focusOut: ->
    @send('formatValue')
