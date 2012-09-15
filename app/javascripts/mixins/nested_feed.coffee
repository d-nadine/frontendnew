Radium.NestedFeed = Ember.Mixin.create
  isFeedController: true

  # TODO: it seems that this would be much better if it worked as
  #       grouped content - by observing content array, rebuilding
  #       it every time is a waste
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

  findRelatedSection: (section) ->
    @find (sectionWrapper) -> sectionWrapper.isRelatedTo section
