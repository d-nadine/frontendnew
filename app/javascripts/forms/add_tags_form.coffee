require 'forms/form'

Radium.AddTagsForm = Radium.Form.extend
  data: ( ->
    tags: @get('tags')
  ).property().volatile()

  reset: ->
    @_super.apply this, arguments
    @set 'tags', Ember.A()

  addTags: ->
    selectedContent = @get('selectedContent').filter (item) ->
      item instanceof Radium.Contact || item instanceof Radium.Company

    return unless selectedContent.length

    tags = @get('data.tags')

    return unless tags.length

    selectedContent.forEach (item) =>
      tags.forEach (tag) =>
        if tag.get('id')
          item.get('tags').addObject tag unless item.get('tags').contains tag
        else
          item.get('tags').createRecord 
            name: tag.get('name')
