Radium.CurrencyInputComponent = Ember.TextField.extend
  type: "text"
  timeout: 1000

  timeoutReference: null

  keyDown: (e) ->
    if e.keyCode == 13
      return @sendAction 'submit'

    accountCurrency = @get('accountCurrency')

    if timeoutReference = @get('timeoutReference')
      clearTimeout(timeoutReference)

    timeoutReference = setTimeout =>
      @formatValue()
    , @get('timeout')

    @set 'timeoutReference', timeoutReference

  focusIn: ->
    return unless value = @get('value')

    if value == "0.00"
      @set('value', null)

  focusOut: ->
    @formatValue()

  # UPGRADE: replace with inject
  accountController: Ember.computed ->
    @container.lookup('controller:account')

  formatValue: ->
    return if @isDestroyed || @isDestroying

    accountCurrency =  @get('accountController').get('accountCurrency')

    settings =
      precision: accountCurrency.precision
      thousand: accountCurrency.thousand
      decimal: accountCurrency.decimal

    val = accounting.formatNumber @get('value'), settings

    @set 'value', val
