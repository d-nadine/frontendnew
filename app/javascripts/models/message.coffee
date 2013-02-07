Radium.Message = Ember.ArrayProxy.extend
  folder: null

  content: (->
    items = []

    emails =  Radium.Email.find folder: @get('folder')
    discussions = Radium.Discussion.find folder: @get('folder')

    emails.one 'didLoad', ->
      items.pushObjects(emails.toArray())

    discussions.one 'didLoad', ->
      items.pushObjects(discussions.toArray())

    items
  ).property('folder')

