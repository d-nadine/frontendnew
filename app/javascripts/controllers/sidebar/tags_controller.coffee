Radium.SidebarTagsController = Radium.ObjectController.extend
  actions:
    addTag: (tag) ->
      return if @get('tagNames').mapProperty('name').contains tag

      tag = @get('tagNames').createRecord(name: tag)

      addressbook = @get('controllers.addressbook.content')

      tagName = tag.get('name')

      tag.one 'didCreate', ->
        Radium.Tag.find({}).then (tags) ->
          if tag = tags.find((tag) -> tag.get('name') == tagName)
            addressbook.pushObject tag

      @get('store').commit()

    removeSelection: (tag) ->
      return unless @get('tagNames').mapProperty('name').contains(tag.get('name'))

      @get('tagNames').removeObject(tag)

      @get('store').commit()

  needs: ['tags', 'addressbook']
  isEditable: true
