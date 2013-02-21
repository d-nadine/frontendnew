require 'views/forms/time_picker_view'
Radium.FormsMeetingView = Ember.View.extend
  checkbox: Radium.FormsCheckboxView.extend()

  topicField: Radium.MentionFieldView.extend
    classNameBindings: ['value:is-valid', 'isInvalid', ':meeting']

    placeholder: 'Add meeting topic'
    valueBinding: 'controller.topic'

    isSubmitted: Ember.computed.alias('controller.isSubmitted')

    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

  datePicker: Radium.FormsDatePickerView.extend
    classNames: ['starts-at']
    dateBinding: 'controller.startsAt'
    leader: 'When:'
    isInvalid: (->
      return false unless @get('isSubmitted')
      return false if Ember.isEmpty(@get('text'))
      return false unless @get('controller.startsAt')

      @get('controller.startsAt').isBeforeToday()
    ).property('isSubmitted', 'controller.startsAt')

  startsAt: Radium.TimePickerView.extend
    leader: 'Starts:'
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

  location:  Radium.MapView.extend
    leader: 'location'

  userList: Radium.FormsAutocompleteView.extend()
