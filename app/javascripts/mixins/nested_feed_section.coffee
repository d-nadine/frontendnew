Radium.NestedFeedSection = Ember.Mixin.create
  section: DS.belongsTo('Radium.FeedSection', key: 'section_id')

  filteredItems: (->
    Ember.ArrayProxy.create(
      Ember.FilterableMixin, {
        store: Radium.store
        context: this
        section: @get('section')
        contentBinding: 'section.items'

        filterProperties: ["#{@get('associatedArrayName')}.length"]
        filterCondition: (item) ->
          id = @get 'context.record.id'
          @get('context').itemFits item
      }
    )
  ).property()

  items: (->
    # TODO: I need to use ArrayProxy here because I need both clustering
    #       and filtering, and both mixins override arrangedContent method.
    #       At this point ember does not support calling super in computed
    #       properties, so there is no other way to use 2 mixins that
    #       override the same property.
    Ember.ArrayProxy.create(
      Radium.ClusteredRecordArray, {
        store: Radium.store
        content: @get('filteredItems')
      }
    )
  ).property()

  date: (->
    @get 'section.date'
  ).property('section.date')

  itemFits: (item) ->
    id   = @get('record.id')
    type = @get('recordType')

    if associatedItems = item.get(@get('associatedArrayName'))
      associatedItems.get('length') &&
         associatedItems.find( (record) ->
           record.get('id') == id && record.constructor == type
         )

  sectionFits: (section) ->
    section.get('items').find (item) -> @itemFits(item)

  isRelatedTo: (section) ->
    @get('section') == section

  nextDate: (->
    section = @get 'section.nextSection'
    while section
      if @sectionFits section
        return section.get 'id'
      else
        section = section.get 'nextSection'

    null
  ).property('section.nextSection')

  previousDate: (->
    section = @get 'section.previousSection'
    while section
      if @sectionFits section
        return section.get 'id'
      else
        section = section.get 'previousSection'

    null
  ).property('section.previousSection')
