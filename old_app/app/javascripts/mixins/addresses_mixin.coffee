Radium.AddressesMixin = Ember.Mixin.create
  defaultAddresses: (hasEmail) ->
    address = Ember.Object.create(name: 'work', isPrimary: true, street: '', line2: '', city: '', state: '', zipcode: '', country: 'US', isCurrent: true
                                        )

    if hasEmail
      address['email'] = ''
    Ember.A([$.extend({}, address), $.extend({}, address, {name: 'home', isCurrent: false, isPrimary: false})])
