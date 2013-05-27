require 'lib/dictionaries'

class RadiumAdapter extends Foundry.EmberDataAdapter
  constructor: (store) ->
    @store = store

    @map = Ember.Map.create()
    @map.set 'address', Radium.Address
    @map.set 'user', Radium.User
    @map.set 'comment', Radium.Comment
    @map.set 'contact', Radium.Contact
    @map.set 'deal', Radium.Deal
    @map.set 'email', Radium.Email
    @map.set 'tag', Radium.Tag
    @map.set 'meeting', Radium.Meeting
    @map.set 'notification', Radium.Notification
    @map.set 'todo', Radium.Todo
    @map.set 'call', Radium.Call
    @map.set 'overdueTodo', Radium.Todo
    @map.set 'attachment', Radium.Attachment
    @map.set 'discussion', Radium.Discussion
    @map.set 'checklist', Radium.Checklist
    @map.set 'checklist_item', Radium.ChecklistItem
    @map.set 'settings', Radium.Settings
    @map.set 'company', Radium.Company
    @map.set 'phoneNumber', Radium.PhoneNumber
    @map.set 'emailAddress', Radium.EmailAddress
    @map.set 'company', Radium.Company
    @map.set 'phone_call', Radium.PhoneCall
    @map.set 'voice_mail', Radium.VoiceMail

Foundry.RadiumAdapter = RadiumAdapter

foundry = new Foundry
foundry.adapter = new RadiumAdapter

foundry.createObject = (klass, attributes) ->
  hash = @build klass, attributes
  Ember.Object.create hash

Ember.Application.initializer
  name: 'foundry'
  after: 'store'
  initialize: (container, application) ->
      Factory.adapter.store = container.lookup 'store:main'

window.Factory = foundry

require 'factories/traits'

requireAll /factories/
