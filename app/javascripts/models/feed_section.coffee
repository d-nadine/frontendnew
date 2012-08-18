# TODO: figure out if this shouldn't be DS.Model, for
#       now I see no point, as we're not actually leveraging
#       adapter/store automation in case of feed but probably
#       it should be changed later on
Radium.FeedSection = Ember.Object.extend
  init: ->
    @_super.apply(this, arguments)

    array = Radium.ExtendedRecordArray.create(store: @get('store'))
    @set('items', array)

  pushItem: (item) ->
    @get('items').pushObject(item)
