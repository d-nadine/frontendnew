require 'lib/radium/time_picker_view'
require 'lib/radium/location_picker'
require 'lib/radium/autocomplete_list_view'
Radium.FormsMeetingView = Ember.View.extend
  classNames: ['meeting-form-container']

  readableStartsAt: ( ->
    @get('controller.startsAt').toHumanFormatWithTime()
  ).property('startsAt')

  didInsertElement: ->
    $('html').on 'click.cancel-meeting', ->
      $('cancel-meeting').hide()

  willDestroyElement: ->
    $('html').off 'click.cancel-meeting'

  showCancelMeetingDialogue: ->
    dialogue =  @$('.cancel-meeting')

    $('html').on 'click.cancel-meeting', ->
      $('html').off 'click.cancel-meeting'
      dialogue.hide()

    dialogue.show()
    false

  cancelMeetingDialogue: Ember.View.extend
    classNames: ['cancel-meeting']
    template: Ember.Handlebars.compile """
      <div class="content">
        <div>Are you sure you want to cancel meeting</div>
        <div>{{view.cancellationText}}</div>
        <div>
          <div>
            <button {{action cancel target="view"}} class="btn btn-no">No</button>
            <button {{action cancelMeeting target="view"}} class="btn btn-danger">YES, CANCEL</button>
          </div>
        </div>
        <div>Notifications will be sent to attendees</div>
      </div>
    """
    cancel: ->
      @$().hide()

    cancelMeeting: ->
      @$().hide()

    cancellationText: ( ->
      topic = @get('controller.topic')

      attendees = @get('controller.attendees').map( (attendee) -> "@#{attendee.get('name')}").join(', ')

      "#{topic} with #{attendees} at #{@get('controller.startsAt').toHumanFormatWithTime()}"
    ).property('topic', 'isNew')

  topicField: Radium.MentionFieldView.extend
    classNameBindings: ['isInvalid', ':meeting']
    disabledBinding: 'controller.isPrimaryInputDisabled'
    placeholder: 'Add meeting topic'
    valueBinding: 'controller.topic'

    isSubmitted: Ember.computed.alias('controller.isSubmitted')

    click: (evt) ->
      evt.stopPropagation()

    keyDown: (evt) ->
      @set('controller.isExpanded', true) unless @get('controller.isExpanded')

    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

  datePicker: Radium.DatePicker.extend
    classNames: ['starts-at']
    dateBinding: 'controller.startsAt'
    leader: 'When:'
    isInvalid: (->
      return false unless @get('isSubmitted')
      return false if Ember.isEmpty(@get('text'))
      return false unless @get('date')

      @get('date').isBeforeToday()
    ).property('isSubmitted', 'controller.startsAt')

  startsAt: Radium.TimePickerView.extend
    leader: 'Starts:'
    dateBinding: 'controller.startsAt'
    isInvalid: ( ->
      return false unless @get('isSubmitted')
      now = Ember.DateTime.create().advance(minute: -5)
      Ember.DateTime.compare(@get('controller.startsAt'), now)  == -1
    ).property('isSubmitted', 'controller.startsAt', 'controller.endsAt', 'date')

  endsAt: Radium.TimePickerView.extend
    dateBinding: 'controller.endsAt'
    leader: 'Ends:'
    isInvalid: ( ->
      return false unless @get('isSubmitted')
      Ember.DateTime.compare(@get('controller.endsAt'), @get('controller.startsAt')) == -1
    ).property('isSubmitted', 'controller.startsAt', 'controller.endsAt', 'date')

  location: Radium.LocationPicker.extend
    valueBinding: 'controller.location'

  userList: Radium.AutocompleteView.extend()
