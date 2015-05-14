Radium.XQueryComponent = Ember.Component.extend
  actions:
    removeQuery: (query) ->
      @get('parent').send 'removeQuery', query

      false

  classNameBindings: [':field']

  selectedOperator: Ember.computed 'query.operator', ->
    switch @get('query.operator')
      when "text" then [
        {value: "equals", text: "is"}
        {value: "not-equals", text: "is not"}
        {value: "like", text: "is like"}
      ]
      when "number" then [
        {value: "greater-than", text: "more than"}
        {value: "less-than", text: "less than"}
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
    contenteditable: "true"

    keyDown:(e)  ->
      if e.keyCode == @ENTER
        text = $(e.target).text() || ''

        unless text.length
          @$().addClass 'is-invalid'

        query = @get('query')

        query.input = text

        @get('parent.parent').send 'modifyQuery', query

        return false

      @$().removeClass('is-invalid') if @$().hasClass('is-invalid')

    _setup: Ember.on 'didInsertElement', ->
      Ember.run.scheduleOnce 'afterRender', this, '_afterRender'

    _afterRender: ->
      @$().focus()
