Radium.PersistTagsMixin = Ember.Mixin.create
  actions:
    addTag: (model, tag) ->
      return if model.get('tagNames').mapProperty('name').contains tag

      if model.get('isNew')
        return if model.get('tagNames').mapProperty('name').contains tag

        newTag = Radium.Tag.createRecord name: tag

        newTag.save()

        return model.get('tagNames').addObject Ember.Object.create name: tag

      tag = model.get('tagNames').createRecord(name: tag)

      addressbook = @get('addressbook.content')

      tagName = tag.get('name')

      tag.save(this).then ->
        Radium.Tag.find({}).then (tags) ->
          if tag = tags.find((tag) -> tag.get('name') == tagName)
            addressbook.pushObject tag

    removeTag: (model, tag) ->
      return unless model.get('tagNames').mapProperty('name').contains(tag.get('name'))

      model.get('tagNames').removeObject(tag)

      model.save()

  # UPGRADE: replace with inject
  tags: Ember.computed ->
    @container.lookup('controller:tags')

  addressbook: Ember.computed ->
    @container.lookup('controller:addressbook')

