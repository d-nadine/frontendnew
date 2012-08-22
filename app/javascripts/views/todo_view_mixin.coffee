Radium.TodoViewMixin = Ember.Mixin.create
  classNames: ['todo']
  classNameBindings: [
    'content.isOverdue',
    'content.finished'
  ]
  checkboxView: Ember.Checkbox.extend
    updatedAtBinding: 'parentView.content.updatedAt'
    finishedBinding: 'parentView.content.finished'
    disabledBinding: 'parentView.content.isSaving'
    checkedBinding: 'parentView.content.finished'
    click: (event) ->
      event.stopPropagation()

    change: ->
      @set('updatedAt', Ember.DateTime.create())
      @_super.apply(this, arguments)

    todoValueDidChange: (->
      Ember.run.next ->
        Radium.store.commit()
    ).observes('checked')
