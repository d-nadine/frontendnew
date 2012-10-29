Radium.TodoFormView = Radium.FormView.extend
  templateName: 'radium/todo_form'

  close: ->
    if @get('controller').close
      @get('controller').close()
    else if (view = @get('parentView')) && !@get('isDestroyed')
      view.set('currentView', null)

  isContact: (->
    @get('selection.kind') is 'contact'
  ).property('selection')

  finishBy: Ember.computed( (key, value) ->
    today = Ember.DateTime.create()
    date = if value
      Ember.DateTime.parse(value, '%Y-%m-%d')
    else
      today

    unless date
      date = today

    if date && date.get('hour') >= 17 and Ember.DateTime.compareDate(date, today) is 0
      date = date.advance(day: 1)

    date
  )

  headerContext: (->
    selection = @get('selection')
    currentYear = (new Date()).getFullYear()
    date = @get('finishBy')
    sameYearString = '%A, %e/%D'
    differentYearString = '%A, %e/%D/%Y'
    format = (if (date.get('year') != currentYear) then differentYearString else sameYearString)
    dateString = date.toFormattedString(format)

    if selection
      name = selection.get('name') or selection.get('reference.name') or selection.get('description') or selection.get('topic')
      'Assign a Todo to “%@” for %@'.fmt name, dateString
    else
      'Add a Todo for %@'.fmt dateString
  ).property('finishBy', 'selection').cacheable()

  descriptionText: Ember.TextArea.extend(Ember.TargetActionSupport,
    elementId: 'description'
    viewName: 'descriptionField'
    attributeBindings: ['name']
    placeholderBinding: 'parentView.headerContext'
    name: 'description'
    classNames: ['span8']
    action: 'submitForm'
    target: 'parentView'
    didInsertElement: ->
      @$().autosize().css 'resize', 'none'

    keyUp: (event) ->
      if @$().val() isnt ''
        @set 'parentView.isValid', true
      else
        @set 'parentView.isValid', false
      @_super event

    keyPress: (event) ->
      if event.keyCode is 13 and not event.ctrlKey
        event.preventDefault()
        @triggerAction() if @$().val() isnt ''

    focusOut: ->
      if @$().val() isnt ''
        @set 'parentView.isValid', true
      else
        @set 'parentView.isValid', false
  )

  isCallCheckbox: Ember.Checkbox.extend
    viewName: 'isCallCheckbox'
    checkedBinding: 'parentView.isContact'

  assignedUser: null

  assignToSelect: Ember.Select.extend
    elementId: 'assigned-to'
    contentBinding: 'Radium.router.usersController'
    optionLabelPath: 'content.displayName'
    optionValuePath: 'content.id'
    didInsertElement: ->
      user = Radium.get('router.meController.user')
      @set 'parentView.assignedUser', user
      @set 'selection', user

    change: ->
      @_super()
      @set 'parentView.assignedUser', @get('selection')

  finishByDateField: Radium.DatePickerField.extend
    elementId: 'finish-by-date'
    name: 'finish-by-date'
    classNames: ['input-small']

    minDate: (->
      now = Ember.DateTime.create()
      (if (now.get('hour') >= 17) then '+1d' else new Date())
    ).property().cacheable()

    # TODO: test if it can be changed
    value: ( (key, value) ->
      if value
        @set 'parentView.finishBy', value
        @get 'parentView.finishBy'
      else
        if finishBy = @get 'parentView.finishBy'
          finishBy.toFormattedString '%Y-%m-%d'
    ).property('parentView.finishBy')

  moveFeed: (->
    if @get 'isGlobalLevelForm'
      date = @get('finishBy').toFormattedString '%Y-%m-%d'
      Radium.get('router').transitionTo 'root.dashboardWithDate', date: date
  ).observes('finishBy')

  submitForm: ->
    doStuff = ->
      selection = @get('selection')
      description = @get('descriptionField.value')
      isCall = @get('isCallCheckbox.checked')

      # TODO: When support todos are added, add logic to toggle this from general to support
      # TODO: is above todo still valid?
      todoKind = 'general'
      finishBy = @get('finishBy')

      assignedUser = @get('assignedUser')
      assignedUserId = assignedUser.get('id')

      data =
        description: description
        finishBy: finishBy
        finished: false
        kind: (if (isCall) then 'call' else todoKind)
        user_id: assignedUserId
        user: assignedUser
        created_at: Ember.DateTime.create()
        updated_at: Ember.DateTime.create()
        hasAnimation: true

      todo = Radium.store.createRecord Radium.Todo, data
      if selection
        todo.set 'reference', selection

      # TODO: feed sections could automatically handle adding
      # new items, but I'm not sure how would hat behave, it needs
      # a check with API or a lot of items
      @get('controller').pushItem(todo)
      Radium.store.commit()

      @close()

    # TODO: I'm not sure how to handle this better at the moment, when
    #       todo is added, the feed is scrolled to show it, if form is
    #       closed at the same moment, feed goes further than it should
    @$().slideUp('fast')
    self = this
    setTimeout (-> doStuff.apply(self) ), 200
