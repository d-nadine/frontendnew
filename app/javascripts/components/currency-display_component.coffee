Radium.CurrencyDisplayComponent = Ember.Component.extend
  classNameBindings: [":selectbox-option"]
  tagName: "span"
  icon: Ember.computed 'currency.flag', ->
    key = @get('currency.key').substr(0, 2)
    "bfh-flag-#{key}"
