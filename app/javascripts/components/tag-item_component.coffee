Radium.TagItemComponent = Ember.Component.extend
  actions:
    showTagsContacts: ->
      @get('parent').send 'showTagsContacts', @get('tag')

      false

    deleteTag: ->
      @get('parent').send 'deleteTag', @get('tag')

      false

    makeTagConfigurable: ->
      @get('parent').send 'makeTagConfigurable', @get('tag')
      false

  classNameBindings: ['isCurrent:active']
  isTagged: Ember.computed.oneWay 'parent.isTagged'
  tagsTotals: Ember.computed.oneWay 'parent.tagsTotals'

  isCurrent: Ember.computed 'parent.tag', 'isTagged', 'tag', ->
    return unless @get('isTagged') && @get('tag')

    @get('tag.id') == @get('parent.tag')

  contactsTotal: Ember.computed 'parent.tag', 'tag', 'tagsTotals', ->
    unless tagsTotals = @get('tagsTotals')
      return

    unless tagId = @get('tag.id')
      return

    tag = tagsTotals.find((tag) -> tag.id == parseInt(tagId))

    if !tag
      Radium.Tag.find({})
      return

    tag.total
