Radium.PersistTagsMixin = Ember.Mixin.create
  actions:
    addTag: (tag) ->
      return if @get('tagNames').mapProperty('name').contains tag

      if @get('isNew')
        return if @get('tagNames').mapProperty('name').contains tag

        newTag = Radium.Tag.createRecord name: tag

        newTag.save()

        return @get('tagNames').addObject Ember.Object.create name: tag

      tag = @get('tagNames').createRecord(name: tag)

      addressbook = @get('controllers.addressbook.content')

      tagName = tag.get('name')

      tag.save(this).then ->
        Radium.Tag.find({}).then (tags) ->
          if tag = tags.find((tag) -> tag.get('name') == tagName)
            addressbook.pushObject tag

    removeTag: (tag) ->
      return unless @get('tagNames').mapProperty('name').contains(tag.get('name'))

      @get('tagNames').removeObject(tag)

      @get('store').commit()

  needs: ['tags', 'addressbook']
  tags: Ember.computed.oneWay 'controllers.tags'

