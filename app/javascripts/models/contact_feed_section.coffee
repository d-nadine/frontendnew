itemFits = (item, type, id) ->
  if associatedContacts = item.get('associatedContacts')
    associatedContacts.get('length') &&
       associatedContacts.find( (record) ->
         record.get('id') == id && record.constructor == type
       )

sectionFits = (section, type, id) ->
  section.get('items').find (item) -> itemFits(item, type, id)

Radium.ContactFeedSection = Radium.FeedSection.extend
  section: DS.belongsTo('Radium.FeedSection', key: 'section_id')
  contact: DS.belongsTo('Radium.Contact',     key: 'contact_id')

  filteredItems: (->
    Ember.ArrayProxy.create(
      Ember.FilterableMixin, {
        store: Radium.store
        context: this
        section: @get('section')
        contentBinding: 'section.items'

        filterProperties: ['associatedContacts.length']
        filterCondition: (item) ->
          id = @get 'context.contact.id'
          itemFits item, Radium.Contact, id
      }
    )
  ).property()

  items: (->
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

  nextDate: (->
    section = @get 'section.nextSection'
    while section
      if sectionFits section, Radium.Contact, @get('contact.id')
        return section.get 'id'
      else
        section = section.get 'nextSection'

    null
  ).property('section.nextSection')

  previousDate: (->
    section = @get 'section.previousSection'
    while section
      if sectionFits section, Radium.Contact, @get('contact.id')
        return section.get 'id'
      else
        section = section.get 'previousSection'

    null
  ).property('section.previousSection')
