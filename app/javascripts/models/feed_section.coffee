Radium.FeedSection = Radium.Core.extend
  date: DS.attr('datetime')
  items: Radium.ExtendedRecordArray.attr(key: 'item_ids')
  pushItem: (item) ->
    @get('items').pushObject(item)
