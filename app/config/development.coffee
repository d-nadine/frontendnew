Ember.Application.registerInjection
  name: 'populate'
  after: 'foundry'
  injection: (app, router, property) ->
    require 'radium/populate'

    Radium.Populator.run() unless Radium.Populator.hasRun
