require 'mixins/containing_controller_mixin'

Radium.CurrencyControlComponent = Ember.Component.extend Radium.KeyConstantsMixin,
  Radium.ContainingControllerMixin,
  actions:
    save: ->
      Ember.run.once this, 'saveValue'

      false

  saveValue: ->
    value = @get('value')

    return unless value = @get('value')
    return if value == "0.00"

    value = accounting.unformat(value)

    return if value == 0

    target = @get('containingController')

    saveAction = @get('saveAction')

    Ember.assert "You need to specify a saveAction for the currencyControl", saveAction

    target.send saveAction, @get('model'), value

  focusOut: (e) ->
    return unless e.target.tagName == 'INPUT'

    return unless e.target?.value?.length

    Ember.run.next =>
      @send "save"

  # UPGRADE: replace with inject
  accountController: Ember.computed ->
    @container.lookup('controller:account')

  localCurrency: Ember.computed ->
    @get('accountController.accountCurrency').symbol
