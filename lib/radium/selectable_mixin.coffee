Radium.SelectableMixin = Ember.Mixin.create
  selectedContent: null

  selectContent: (event) ->
    object = event.context
    @set 'selectedContent', object
