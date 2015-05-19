Radium.XQueryComponent = Ember.Component.extend
  actions:
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

      editable = @$('.value')

      text = editable?.text() || ''

      if !isBoolean &&  !!!text.length
        editable?.addClass 'is-invalid'
        return false

      index = @get('index')

      return unless @get('parent.potentialQueries').objectAt index

      unless isBoolean
        query =
          field: q.field,
          operatorType: q.operatorType
          operator: q.operator || @get('operatorSelection')[0].value
          value: text
      else
        query =
          field: q.field,
          operatorType: q.operatorType
          operator: "exists"
          value: q.operator || @get('operatorSelection')[0].value

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

  isBoolean: Ember.computed 'query.operatorType', ->
    @get('query.operatorType') == "boolean"

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

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
