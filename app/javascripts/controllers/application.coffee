require 'radium/views/application'

Radium.ApplicationController = Em.Controller.extend
  bootstrap: ->
    Radium.store.bootstrap()
