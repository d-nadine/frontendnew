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
    @map.set 'todo', Radium.Todo
    @map.set 'call', Radium.Todo
    @map.set 'overdueTodo', Radium.Todo
    @map.set 'attachment', Radium.Attachment
    @map.set 'settings', Radium.Settings
    @map.set 'discussion', Radium.Discussion

Foundry.RadiumAdapter = RadiumAdapter

foundry = new Foundry
foundry.adapter = new RadiumAdapter

Ember.Application.initializer
  name: 'foundry'
  after: 'store'
  initialize: (container, application) ->
      Factory.adapter.store = container.lookup 'store:main'

window.Factory = foundry

require 'factories/traits'

requireAll /factories/
