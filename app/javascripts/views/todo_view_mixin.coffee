Radium.TodoViewMixin = Ember.Mixin.create
  classNames: ['todo']
  classNameBindings: ['isOverdue', 'finished']
  finishedBinding: 'content.finished'
  isOverdueBinding: 'content.isOverdue'
  checkboxView: Ember.Checkbox.extend
    updatedAtBinding: 'parentView.content.updatedAt'
    finishedBinding: 'parentView.finished'
    disabledBinding: 'parentView.content.isSaving'
    checkedBinding: 'parentView.finished'
    click: (event) ->
      event.stopPropagation()

    change: ->
      @set('updatedAt', Ember.DateTime.create())
      @_super.apply(this, arguments)

    todoValueDidChange: (->
      Ember.run.next ->
        Radium.store.commit()
    ).observes('checked')
