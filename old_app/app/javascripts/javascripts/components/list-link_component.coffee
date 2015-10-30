Radium.ListLinkComponent = Ember.Component.extend
  tagName: 'a'
  attributeBindings: ['href', 'dataListId:data-list-id']
  classNames: ['nav-bar-list']

  href: "#"

  dataListId: Ember.computed.oneWay 'list.id'

  click: (e) ->
    @sendAction "transitionToList", @get('list')

    e.stopPropagation()
    e.preventDefault()

    false
