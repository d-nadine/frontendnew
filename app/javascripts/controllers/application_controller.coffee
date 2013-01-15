Radium.ApplicationController = Em.Controller.extend
  development: (->
    Iridium.env == 'development'
  ).property()
