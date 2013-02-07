Radium.Message = Ember.ArrayProxy.extend
  folder: null

  content: (->
    items = []

    # FIXME: wait for didLoad on rea data
    emails =  Radium.Email.find folder: @get('folder')
    discussions = Radium.Discussion.find folder: @get('folder')

    emails.one 'didLoad', ->
      emails.forEach (email) -> items.pushObject(email)

    discussions.one 'didLoad', ->
      items.pushObjects(discussions.toArray())

    items
  ).property('folder')

