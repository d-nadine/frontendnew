Radium.XQueryComponent = Ember.Component.extend
  actions:
    queryByUser: (user) ->
      @executeQuery()

      false

    removeQuery: (query) ->
      @get('parent').send 'removeQuery', query, @get('index')

      false

    changeOperator: ->
      @sendQuery()

      return false

  sendQuery: ->
    Ember.run.debounce this, @executeQuery, 300

  executeQuery: ->
    Ember.run.next =>
      q = @get('query')
      isBoolean = @get('isBoolean')
      isGeneric = @get('isGeneric')
      isUser = @get('isUser')

      editable = @$('.value')

      text = editable?.text() || ''

      if isGeneric  &&  !!!text.length
        editable?.addClass 'is-invalid'
        return false

      index = @get('index')

      potentialQueries = @get('parent.potentialQueries')

      return unless potentialQueries && potentialQueries.objectAt(index)

      getOperator = (q) =>
                       if isBoolean
                         "exists"
                       else if isUser
                         "equals"
                       else
                         q.operator || @get('operatorSelection')[0].value

      getValue = (q) =>
                    if isBoolean
                      q.value || @get('operatorSelection')[0].value
                    else if isUser
                      q.value.get('id')
                    else
                      text
      query =
        field: q.field,
        operatorType: q.operatorType
        operator: getOperator(q)
        value: getValue(q)
        customfieldid: q?.customfieldid

      @get('parent').send "modifyQuery", query, index

    false

  classNameBindings: [':field']

  operatorSelection: Ember.computed 'query.operatorType', ->
    switch @get('query.operatorType')
      when "text" then [
        {value: "like", text: "is like"}
        {value: "equals", text: "is"}
        {value: "not_equals", text: "is not"}
      ]
      when "number" then [
        {value: "greater_than", text: "more than"}
        {value: "less_than", text: "less than"}
      ]
      when "boolean" then [
        {value: "true", text: "Exists"}
        {value: "false", text: "Not exists"}
      ]

  queryPlaceholder: Ember.computed 'query.operator', ->
    switch @get('query.operator')
      when "text" then "something"
      when "number" then "days"

  isBoolean: Ember.computed.equal 'query.operatorType', 'boolean'

  isUser: Ember.computed.equal 'query.operatorType', 'user'

  isGeneric: Ember.computed 'query.operatorType', ->
    !['boolean', 'user'].contains @get('query.operatorType')

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    if @get('isUser')
      if /^\d+/g.test @query.value
        user = @get('users').find (u) => u.get('id') == @query.value
        return @set 'query.value', user

    return unless @get('isBoolean')

    @executeQuery()

  queryValue: Ember.View.extend Radium.KeyConstantsMixin,
    classNameBindings: [':value']
    attributeBindings: ['contenteditable', 'placeholder']
    placeholder: Ember.computed.oneWay 'controller.queryPlaceholder'
    parent: Ember.computed.oneWay 'controller.parent'
    query: Ember.computed.oneWay 'controller.query'
    operatorSelection: Ember.computed.oneWay 'controller.operatorSelection'
    index: Ember.computed.oneWay 'controller.index'
    contenteditable: "true"

    keyDown:(e)  ->
      if e.keyCode == @ENTER
        return false

      @$().removeClass('is-invalid') if @$().hasClass('is-invalid')

      @get('controller').sendQuery()

    _setup: Ember.on 'didInsertElement', ->
      Ember.run.scheduleOnce 'afterRender', this, '_afterRender'

      if value = @get('query.value')
        @$().text(value)

    _afterRender: ->
      @$().focus()
