Radium.FormsDatePickerView = Ember.View.extend
  classNameBindings: [
    'date:is-valid'
    'disabled:is-disabled'
    'isInvalid'
    ':control-box'
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
    return if @$('.datepicker-link').length is 0

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
    {{#if view.disabled}}
      <i class="icon-calendar"></i>
    {{else}}
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
    {{/if}}
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
