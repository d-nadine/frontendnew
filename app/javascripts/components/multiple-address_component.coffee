Radium.MultipleAddressComponent = Ember.Component.extend
  setup: Ember.on 'didInsertElement', ->
    p "here"

    focusIn: (e) ->
      p e.target
