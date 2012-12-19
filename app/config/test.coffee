#ensure there is a blank FIXTURES array for all types.
#To avoid having to do it in each test setup.
Ember.Application.registerInjection
  name: 'inittypes'
  before: 'store'
  injection: (app, router, property) ->
    type = Radium.Core.typeFromString(property)
    type.FIXTURES ||= Ember.A() if DS.Model.detect(type)

Ember.ENV.RAISE_ON_DEPRECATION = true
