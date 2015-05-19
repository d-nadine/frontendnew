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

      editable = @$('.value')

      text = editable?.text() || ''

      unless text.length
        editable?.addClass 'is-invalid'
        return false

      return unless text.length

      index = @get('index')

      return unless @get('parent.potentialQueries').objectAt index

      query =
        field: q.field,
        operatorType: q.operatorType
        operator: q.operator || @get('operatorSelection')[0].value
        value: text

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
        {value: "less_than", text: "less than"}
        {value: "greater_than", text: "more than"}
      ]

  queryPlaceholder: Ember.computed 'query.operator', ->
    switch @get('query.operator')
      when "text" then "something"
      when "number" then "days"

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
