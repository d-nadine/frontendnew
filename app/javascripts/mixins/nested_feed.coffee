Radium.NestedFeed = Ember.Mixin.create
  arrangedContent: (->
    recordType = @get 'recordType'
    recordId   = @get 'recordId'

    if content = @get 'content'
      content.map (section) ->
        id = "#{section.get('id')}##{recordId}"
        Radium.store.load(recordType, id, {
          id: id
          section_id: section.get('id')
          record_id: recordId
        })
        Radium.store.find recordType, id

  ).property('content', 'content.length')
