Radium.SidebarTagsController = Radium.ObjectController.extend
  needs: ['tags']
  isEditable: true

  addTag: (tag) ->
    return if @get('tagNames').find (existing) ->
      existing.get('name') == tag.get('name')

    @get('tagNames').createRecord
      name: tag.get('name')

    @get('store').commit()

  removeSelection: (tag) ->
    return unless @get('tags').find (existing) ->
      existing.get('name') == tag.get('name')

    @get('tagNames').removeObject(tag)

    @get('store').commit()
