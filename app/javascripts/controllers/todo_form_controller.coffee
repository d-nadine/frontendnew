Radium.TodoFormController = Ember.ObjectController.extend
  kind: 'general'
  init: ->
    @reset()

  isValid: (->
    @get 'isDescriptionValid'
  ).property('isDescritionValid')

  isDescriptionValid: (->
    !Ember.empty @get('description')
  ).property('description')

  submit: ->
    return unless @get('isValid')
    @get('content').commit()

  reset: ->
    @set 'content', Radium.Todo.createRecord
      kind: @get('kind')
      finishBy: Ember.DateTime.create().advance(day: 1)
      user: Radium.get('router.currentUser')
