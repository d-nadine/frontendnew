Radium.AddressesMixin = Ember.Mixin.create
  defaultAddresses: ->
    address = Ember.Object.create(name: 'work', isPrimary: true, street: '', city: '', state: '', zipcode: '', country: 'US', isCurrent: true)
    Ember.A([$.extend({}, address), $.extend({}, address, {name: 'home', isCurrent: false})])
