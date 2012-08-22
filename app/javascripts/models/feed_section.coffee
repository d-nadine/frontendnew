Radium.FeedSection = DS.Model.extend
  date: DS.attr('datetime')
  itemIds: DS.attr('array', key: 'item_ids')
  items: ( ->
    store = @get('store')

    ids = @get('itemIds').map (element) ->
      [type, id] = element
      record = store.find(type, id)
      [type, record.get('clientId')]

    Radium.ExtendedRecordArray.create
      store: @get('store')
      content: ids
  ).property('itemIds')
  pushItem: (item) ->
    @get('items').pushObject(item)
