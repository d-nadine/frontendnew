Radium.CurrencyDisplayComponent = Ember.Component.extend
  classNameBindings: [":selectbox-option"]
  tagName: "span"
  icon: Ember.computed 'currency.flag', ->
    "bfh-flag-#{@get('currency.key')}"
