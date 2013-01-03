Radium.FormController = Em.Object.extend
  show: (type, selection) ->
    @set 'selection', selection
    @set 'type',      type

  pushItem: (item) ->
    Radium.get('router.feedController').pushItem(item)

  createFeedItem: (type, item, ref) ->
    Radium.get('router.feedController').createFeedItem(type, item, ref)

  close: ->
    @set 'type', null
