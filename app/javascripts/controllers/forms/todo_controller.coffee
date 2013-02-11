Radium.FormsTodoController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  kind: 'todo'
  init: ->
    @reset()

  isValid: (->
    @get 'isDescriptionValid'
  ).property('isDescritionValid')

  isDescriptionValid: (->
    !Ember.isEmpty @get('description')
  ).property('description')

  submit: ->
    return unless @get('isValid')
    @get('model').commit()
    Radium.Utils.notify('Todo created!')

  reset: ->
    @set 'model', Radium.Todo.createRecord
      kind: @get('kind')
      finishBy: Ember.DateTime.create().advance(day: 1)
      user: @get('currentUser')
