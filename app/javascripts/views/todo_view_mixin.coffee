Radium.TodoViewMixin = Ember.Mixin.create
  classNames: ['todo']
  classNameBindings: [
    'content.isOverdue:overdue',
    'content.finished:finished'
  ]
  checkboxView: Ember.Checkbox.extend
    updatedAtBinding: 'parentView.content.updatedAt'
    finishedBinding: 'parentView.content.finished'
    disabledBinding: 'parentView.content.isSaving'
    checkedBinding: 'parentView.content.finished'
    click: (event) ->
      event.stopPropagation()

    change: ->
      this.set('updatedAt', Ember.DateTime.create())
      this._super()

    todoValueDidChange: (->
      Ember.run.next ->
        Radium.store.commit();
    ).observes('checked')
