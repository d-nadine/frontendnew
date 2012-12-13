Ember.Application.registerInjection
  name: 'populate'
  after: 'foundry'
  injection: (app, router, property) ->
    minispade.require 'radium/populate'

    Radium.Populator.run() unless Radium.Populator.hasRun
