Radium.FormController = Em.Object.extend
  show: (type, selection) ->
    @set 'selection', selection
    @set 'type',      type

  pushItem: (item) ->
    Radium.get('router.feedController').pushItem(item)

  close: ->
    @set 'type', null
