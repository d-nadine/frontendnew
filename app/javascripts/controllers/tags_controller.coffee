Radium.TagsController = Radium.ArrayController.extend
  sortProperties: ['name']

  configurableTags: Ember.computed 'model.[]', 'model.@each.configurable', ->
    @get('model').filter (tag) -> tag.get('configurable')