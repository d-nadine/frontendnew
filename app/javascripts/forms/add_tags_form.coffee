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

    all = Radium.Tag.all().map (tag) -> tag.get('name').toLowerCase()

    tagNames.forEach (tag) =>
      tagName = tag.get('name').toLowerCase()

      unless (all.contains(tagName))
        tag = Radium.Tag.createRecord name: tag.get('name')

        tag.one 'didCreate', (result) =>
            model = @get('controller.model')
            model.addObject result

          selectedContent.forEach (item) =>
            item.get('tagNames').addObject Radium.TagName.createRecord name: tag.get('name')

          @get('store').commit()
      else
        selectedContent.forEach (item) =>
          item.get('tagNames').addObject Radium.TagName.createRecord name: tag.get('name')
