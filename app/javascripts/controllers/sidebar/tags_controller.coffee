Radium.SidebarTagsController = Radium.ObjectController.extend
  needs: ['tags']
  isEditable: true

  addTag: (tag) ->
    return if @get('tagNames').mapProperty('name').contains tag

    @get('tagNames').createRecord(name: tag)

    @get('store').commit()

  removeSelection: (tag) ->
    return unless @get('tagNames').mapProperty('name').contains tag

    @get('tagNames').removeObject(tag)

    @get('store').commit()
