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
    @map.set 'invitation', Radium.Invitation
    @map.set 'meeting', Radium.Meeting
    @map.set 'notification', Radium.Notification
    @map.set 'phone_call', Radium.PhoneCall
    @map.set 'reminder', Radium.Reminder
    @map.set 'todo', Radium.Todo
    @map.set 'overdueTodo', Radium.Todo
    @map.set 'message', Radium.Message

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

require 'radium/factories/user'

require 'radium/factories/comment'
require 'radium/factories/contact'
require 'radium/factories/deal'
require 'radium/factories/email'
require 'radium/factories/group'
require 'radium/factories/meeting'
require 'radium/factories/invitation'
require 'radium/factories/notification'
require 'radium/factories/phone_call'
require 'radium/factories/message'
require 'radium/factories/reminder'
require 'radium/factories/todo'
require 'radium/factories/feed_section'
