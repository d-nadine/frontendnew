class RadiumAdapter extends Foundry.EmberDataAdapter
  constructor: (store) ->
    @store = store

    @map = Ember.Map.create()
    @map.set 'user', Radium.User
    @map.set 'comment', Radium.Comment
    @map.set 'contact', Radium.Contact
    @map.set 'deal', Radium.Deal
    @map.set 'email', Radium.Email
    @map.set 'group', Radium.Group
    @map.set 'meeting', Radium.Meeting
    @map.set 'notification', Radium.Notification
    @map.set 'phone_call', Radium.PhoneCall
    @map.set 'reminder', Radium.Reminder
    @map.set 'todo', Radium.Todo
    @map.set 'overdueTodo', Radium.Todo
    @map.set 'attachment', Radium.Attachment

Foundry.RadiumAdapter = RadiumAdapter

foundry = new Foundry
foundry.adapter = new RadiumAdapter

# Ember.Application.initializer
#   name: 'foundry'
#   after: 'store'
#   initialize: (container, application) ->
#       Factory.adapter.store = app.get 'store'

window.Factory = foundry

require 'radium/factories/traits'

requireAll /radium\/factories/
