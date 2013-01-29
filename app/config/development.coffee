Ember.Application.initializer
  name: 'populator'
  after: 'foundry'
  initialize: (container, application) ->
      require 'radium/populate'
      Radium.Populator.run()
