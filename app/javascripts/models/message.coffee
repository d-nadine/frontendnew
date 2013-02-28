Radium.Message = Ember.ArrayProxy.extend
  folder: null

  content: (->
    items = []

    Radium.Email.find(folder: @get('folder')).then (results) ->
      items.pushObjects results.toArray()

    Radium.Discussion.find(folder: @get('folder')).then (results) ->
      items.pushObjects results.toArray()

    items
  ).property('folder')

