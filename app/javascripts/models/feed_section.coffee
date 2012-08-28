Radium.FeedSection = Radium.Core.extend
  date: DS.attr('datetime')
  items: ( ->
    store = @get('store')

    ids = @get('data.item_ids').map (element) ->
      [type, id] = element
      record = store.find(type, id)
      [type, record.get('clientId')]

    Radium.ExtendedRecordArray.create
      store: @get('store')
      content: Ember.A(ids)
  ).property()
  pushItem: (item) ->
    @get('items').pushObject(item)
