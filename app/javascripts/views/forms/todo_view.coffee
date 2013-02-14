Radium.FormsTodoView = Ember.View.extend

  # didInsertElement: ->
  #   @$(window).on 'resize', @get('windowDidResize')
  #   @resizeTodoBox()

  # willDestroyElement: ->
  #   @$(window).off 'resize', @get('windowDidResize')

  # resizeTodoBox: ->
  #   newWidth = @$('.main').width() - @$('.checker').width() - @$('.main a').width() - 70
  #   @$('.todo').width(newWidth)

  # windowDidResize: (->
  #   $.proxy @resizeTodoBox, this
  # ).property()

  checkbox: Ember.View.extend
    disabled: Ember.computed.alias('controller.isDisabled')
    click: (event) ->
      event.stopPropagation()

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
      <input type="checkbox" id="{{unbound view.checkBoxId}}" {{bindAttr disabled=view.disabled}}/>
      <label for="{{unbound view.checkBoxId}}"></label>
    """

  todoField: Ember.TextArea.extend
    classNameBindings: ['value:is-valid', 'isInvalid', ':todo']
    valueBinding: 'controller.description'

    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

    rows: 1
    disabled: (->
      if @get('controller.isDisabled')
        true
      else if(!@get('controller.isNew') && !@get('controller.isExpanded'))
        true
      else
        false
    ).property('controller.isNew', 'controller.isExpanded')

    didInsertElement: ->
      @$().autosize()

    willDestroyElement: ->
      @$().off('autosize')

    placeholder: (->
      if @get('reference.name')
        "Add a todo about #{@get('reference.name')}"
      else
        "Add a todo..."
    ).property('reference.name')

    tabindex: 1

  datePicker: Ember.View.extend
    classNameBindings: [
      'date:is-valid', 
      'isInvalid'
      ':control-box',
      ':datepicker-control-box'
    ]

    dateBinding: 'controller.finishBy'
    textBinding: 'textToDateTransform'
    disabled: Ember.computed.alias('controller.isDisabled')

    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

    textToDateTransform: ((key, value) ->
      if arguments.length == 2
        if value && /\d{4}-\d{2}-\d{2}/.test(value)
          @set 'date', Ember.DateTime.parse(value, '%Y-%m-%d')
        else
          @set 'date', null
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
          <li><a {{action setDate 'today' target=view}}>Today</a></li>
          <li><a {{action setDate 'tomorrow' target=view}}>Tomorrow</a></li>
          <li><a {{action setDate 'this_week' target=view}}>Later This Week</a></li>
          <li><a {{action setDate 'next_week' target=view}}>Next Week</a></li>
          <li><a {{action setDate 'next_month' target=view}}>In a Month</a></li>
          <li>
            <a class="datepicker-link" data-date="{{unbound view.defaultDate}}" href="#">
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
      disabledBinding: 'parentView.disabled'


  userPicker: Ember.View.extend
    classNameBindings: [
      'user:is-valid', 
      'isInvalid',
      ':control-box',
      ':datepicker-control-box'
    ]

    disabled: Ember.computed.alias('controller.isDisabled')
    userBinding: 'controller.user'
    nameBinding: 'nameToUserTransform'

    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

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
      disabledBinding: 'parentView.disabled'

      didInsertElement: ->
        @$().typeahead source: @source

      # FIXME: make this async
      source: (query, process) ->
        Radium.User.all().map((c) -> c.get('name')).toArray()

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
