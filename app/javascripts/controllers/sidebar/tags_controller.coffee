Radium.SidebarTagsController = Radium.ObjectController.extend
  actions:
    addTag: (tag) ->
      return if @get('tagNames').mapProperty('name').contains tag

      @get('tagNames').createRecord(name: tag)

      @get('store').commit()

    removeSelection: (tag) ->
      return unless @get('tagNames').mapProperty('name').contains tag

      @get('tagNames').removeObject(tag)

      @get('store').commit()

  needs: ['tags']
  isEditable: true
