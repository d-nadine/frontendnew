Radium.FormsTodoView = Ember.View.extend
  # keyPress: (event) ->
  #   return unless event.keyCode == 13
  #   @submit()

  setDate: (key) ->
    date = switch key
      when 'today'
        Ember.DateTime.create().atEndOfDay()
      when 'tomorrow'
        Ember.DateTime.create().advance(day: 1)
      when 'this_week'
        Ember.DateTime.create().atEndOfWeek()
      when 'next_week'
        Ember.DateTime.create().advance(day: 7)
      when 'next_month'
        Ember.DateTime.create().advance(month: 1)

    @set 'controller.finishBy', date

  showDatePicker: ->
    @$('.date-control .text').click()

  changeDate: ->
    console.log 'weee'

  checkbox: Ember.View.extend
    init: ->
      @_super.apply this, arguments
      @on "change", this, this._updateElementValue

    _updateElementValue: ->
      @set 'checked', this.$('input').prop('checked')

    checkedBinding: 'controller.isFinished'
    classNames: ['checker']
    tabindex: 4
    checkBoxId: (->
      "checker-#{@get('elementId')}"
    ).property()

    template: Ember.Handlebars.compile """
      <input type="checkbox" id="{{unbound view.checkBoxId}}" />
      <label for="{{unbound view.checkBoxId}}"></label>
    """

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
    <span class="formatted-text">
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

  userSelector: Ember.View.extend
    classNameBindings: [
      'user:is-valid', 
      ':select-user-control',
      ':input-prepend', 
      ':input-append'
    ]

    userBinding: 'controller.user'

    nameBinding: 'nameToUserTransform'

    nameToUserTransform: ((key, value) ->
      if arguments.length == 2
        result = Radium.User.all().find (user) =>
          user.get('name') is value
        @set 'user', result
      else if !value && @get('user')
        @get 'user.name'
      else
        value
    ).property()

    template: Ember.Handlebars.compile """
      <span class="add-on">
        Assigned To
      </span>

      {{view view.textField}}
      <div class="btn-group">
        <button class="btn dropdown-toggle" data-toggle="dropdown">
          <i class="icon-chevron-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each users}}
            <li><a {{action setName this.name target=view href=true}}>{{name}}</a></li>
          {{/each}}
        </ul>
      </div>
    """

    setName: (name) ->
      @set 'name', name

    textField: Ember.TextField.extend
      valueBinding: 'parentView.name'

      didInsertElement: ->
        @$().typeahead source: @source

      # FIXME: make this async
      source: (query, process) ->
        Radium.User.all().map((c) -> c.get('name')).toArray()

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
    @focusDescription()
