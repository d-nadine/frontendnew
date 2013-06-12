Radium.SidebarTagsController = Radium.ObjectController.extend
  needs: ['tags']
  isEditable: true

  addTag: (tag) ->
    name = if typeof tag == "string" then tag else tag.get('name')

    return if @get('tags').find (existing) ->
      existing.get('name') == name

    if typeof tag == "string"
      @get('tags').createRecord
        name: name
    else
      @get('tags').addObject tag

    @get('store').commit()

  removeSelection: (tag) ->
    return unless @get('tags').find (existing) ->
      existing.get('name') == tag.get('name')

    @get('tags').removeObject(tag)

    @get('store').commit()
