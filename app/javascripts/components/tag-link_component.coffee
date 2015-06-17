Radium.TagLinkComponent = Ember.Component.extend
  tagName: 'a'
  attributeBindings: ['href', 'dataTagId:data-tag-id']
  classNames: ['nav-bar-tag']

  href: "#"

  dataTagId: Ember.computed.oneWay 'tag.id'

  click: (e) ->
    @sendAction "transitionToTag", @get('tag')

    e.stopPropagation()
    e.preventDefault()

    false
