Radium.PeopleTagItemController = Radium.ObjectController.extend
  isTagged: Ember.computed.oneWay 'parentController.isTagged'
  tag: Ember.computed.oneWay 'parentController.tag'
  tagsTotals: Ember.computed.oneWay 'parentController.tagsTotals'

  isCurrent: Ember.computed 'model', 'isTagged', 'tag', ->
    return unless @get('isTagged') && @get('tag')

    @get('model.id') == @get('tag')

  contactsTotal: Ember.computed 'model', 'tagsTotals', ->
    unless tagsTotals = @get('tagsTotals')
      return

    unless tagId = @get('model.id')
      return

    tagsTotals.find((tag) -> tag.id == parseInt(tagId)).total