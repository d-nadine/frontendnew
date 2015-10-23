Radium.ListItemComponent = Ember.Component.extend
  actions:
    makeListConfigurable: ->
      @get('parent').send 'makeListConfigurable', @get('list')
      false

    showListsContacts: ->
      @get('parent').send 'showListsContacts', @get('list')

      false

    deleteList: ->
      @get('parent').send 'deleteList', @get('list')

      false

  classNameBindings: ['isCurrent:active', 'list.configurable:is-configured']
  isListed: Ember.computed.oneWay 'parent.isListed'
  listsTotals: Ember.computed.oneWay 'parent.listsTotals'

  isCurrent: Ember.computed 'parent.list', 'isListed', 'list', ->
    return unless @get('isListed') && @get('list')

    @get('list.id') == @get('parent.list')

  contactsTotal: Ember.computed 'parent.list', 'list', 'listsTotals', ->
    unless listsTotals = @get('listsTotals')
      return

    unless listId = @get('list.id')
      return

    list = listsTotals.find((list) -> list.id == parseInt(listId))

    if !list
      Radium.List.find({})
      return

    list.total
