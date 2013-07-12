require 'forms/form'

Radium.AddTagsForm = Radium.Form.extend
  data: ( ->
    tagNames: @get('tagNames')
  ).property().volatile()

  reset: ->
    @_super.apply this, arguments
    @set 'tagNames', Ember.A()

  addTags: ->
    selectedContent = @get('selectedContent').filter (item) ->
      item instanceof Radium.Contact || item instanceof Radium.Company

    return unless selectedContent.length

    tagNames = @get('data.tagNames')

    return unless tagNames.length

    selectedContent.forEach (item) =>
      tagNames.forEach (tag) =>
        unless item.get('tagNames').mapProperty('name').contains(tag.get('name'))
          item.get('tagNames').addObject Radium.TagName.createRecord name: tag.get('name')
