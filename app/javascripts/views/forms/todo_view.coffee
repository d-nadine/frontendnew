Radium.FormsTodoView = Ember.View.extend
  # keyPress: (event) ->
  #   return unless event.keyCode == 13
  #   @submit()

  showDatePicker: ->
    @$('.due-date').focus()

  changeDate: ->
    console.log 'weee'

  checkbox: Ember.Checkbox.extend
    checkedBinding: 'controller.isFinished'
    tabindex: 4

  todoField: Ember.TextField.extend
    classNames: 'todo'
    valueBinding: 'controller.description'
    date: Ember.computed.alias('controller.finishBy')

    placeholder: (->
      "Add a todo for #{@get('date').toHumanFormat()}"
    ).property('date')

    tabindex: 1

  autocomplete: Ember.TextField.extend
    valueBinding: 'controller.referenceName'

    placeholder: "Type a name"

    tabindex: 2

    didInsertElement: ->
      @$().typeahead source: @source

    # FIXME: make this async
    source: (query, process) ->
      Radium.Contact.all().map((c) -> c.get('name')).toArray()

  dueDateField: Ember.View.extend
    attributeBindings: ['defaultDate:data-date']
    classNames: ['text']
    objectBinding: 'controller.finishBy'
    leader: "Due"

    template: Ember.Handlebars.compile """
    <span class="leader">{{view.leader}}</span>
    <span class="formatted-date">
      {{view.formattedDate}}
    </span>
    """

    defaultDate: (->
      (@get('object') || Ember.DateTime.create()).toDateFormat()
    ).property()

    formattedDate: (->
      @get('object').toFormattedString('%A %B %d')
    ).property('object')

    didInsertElement: ->
      @$().datepicker()

      view = this

      @$().data('datepicker').place = ->
        offset = if @component then @component.offset() else @element.offset()
        @picker.css
          top: offset.top + @height,
          left: offset.left - 39

      @$().data('datepicker').set = ->
        view.set 'object', Ember.DateTime.create(@date.getTime())
        @hide()

  userSelector: Ember.Select.extend
    contentBinding: 'controller.users'
    valueBinding: 'controller.user'
    optionLabelPath: 'content.meIfCurrent'
    optionValuePath: 'content.content'

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
    @focusDescription()
