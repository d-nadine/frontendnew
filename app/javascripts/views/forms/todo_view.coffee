Radium.FormsTodoView = Ember.View.extend
  # keyPress: (event) ->
  #   return unless event.keyCode == 13
  #   @submit()

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

  datePicker: Ember.View.extend
    classNameBindings: [
      'date:is-valid', 
      ':control-box',
      ':datepicker-control-box'
    ]

    dateBinding: 'controller.finishBy'
    textBinding: 'textToDateTransform'

    textToDateTransform: ((key, value) ->
      if arguments.length == 2
        # FIXME: replace this with date parsing
      else if !value && @get('date')
        @get('date').toHumanFormat()
      else
        value
    ).property()

    defaultDate: (->
      Ember.DateTime.create().toDateFormat()
    ).property()

    didInsertElement: ->
      @$('.datepicker-link').datepicker()

      view = this

      @$('.datepicker-link').data('datepicker').place = ->
        mainButton = view.$('.btn.dropdown-toggle')

        offset = mainButton.offset()

        @picker.css
          top: offset.top + @height,
          left: offset.left

      @$('.datepicker-link').data('datepicker').set = ->
        view.set 'text', Ember.DateTime.create(@date.getTime()).toDateFormat()
        @hide()

    template: Ember.Handlebars.compile """
      <div class="btn-group">
        <button class="btn dropdown-toggle" data-toggle="dropdown">
          <i class="icon-calendar"></i>
        </button>
        <ul class="dropdown-menu">
          <li><a {{action setDate 'today' target=view href=true}}>Today</a></li>
          <li><a {{action setDate 'tomorrow' target=view href=true}}>Tomorrow</a></li>
          <li><a {{action setDate 'this_week' target=view href=true}}>Later This Week</a></li>
          <li><a {{action setDate 'next_week' target=view href=true}}>Next Week</a></li>
          <li><a {{action setDate 'next_month' target=view href=true}}>In a Month</a></li>
          <li>
            <a class="datepicker-link" data-date="{{unbound view.defaultDate}}">
              <i class="icon-calendar"></i>Pick a Date
            </a>
          </li>
        </ul>
      </div>
      <span class="text">Due</span>
      {{view view.humanTextField}}
    """

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

      @set 'text', date.toHumanFormat()

    humanTextField: Ember.TextField.extend
      valueBinding: 'parentView.text'


  userPicker: Ember.View.extend
    classNameBindings: [
      'user:is-valid', 
      ':control-box',
      ':datepicker-control-box'
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
      <span class="text">
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
