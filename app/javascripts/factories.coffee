class RadiumAdapter extends Foundry.EmberDataAdapter
  constructor: (store) ->
    @store = store

    @map = Ember.Map.create()
    @map.set 'user', Radium.User
    @map.set 'comment', Radium.Comment
    @map.set 'contact', Radium.Contact
    @map.set 'deal', Radium.Deal
    @map.set 'email', Radium.Email
    @map.set 'feed_section', Radium.FeedSection
    @map.set 'group', Radium.Group
    @map.set 'meeting', Radium.Meeting
    @map.set 'notification', Radium.Notification
    @map.set 'phone_call', Radium.PhoneCall
    @map.set 'reminder', Radium.Reminder
    @map.set 'todo', Radium.Todo
    @map.set 'overdueTodo', Radium.Todo

Foundry.RadiumAdapter = RadiumAdapter

foundry = new Foundry
foundry.adapter = new RadiumAdapter

Ember.Application.registerInjection
  name: 'foundry'
  after: 'store'
  injection: (app, router, property) ->
    if property == 'router'
      Factory.adapter.store = app.get 'router.store'

window.Factory = foundry

require 'radium/factories/traits'

requireAll /radium\/factories/
