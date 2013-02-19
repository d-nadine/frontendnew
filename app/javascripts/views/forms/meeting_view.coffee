require 'views/forms/time_picker_view'
Radium.FormsMeetingView = Ember.View.extend
  checkbox: Radium.FormsCheckboxView.extend()

  topicField: Radium.MentionFieldView.extend
    placeholder: 'Add meeting topic'
    valueBinding: 'controller.topic'

  topicField: Radium.MentionFieldView.extend
    classNames: ['meeting']
    placeholder: 'Add meeting topic'

  datePicker: Radium.FormsDatePickerView.extend
    classNames: ['starts-at']
    dateBinding: 'controller.startsAt'
    leader: 'When:'

  startsAt: Radium.TimePickerView.extend
    leader: 'Starts:'

  endsAt: Radium.TimePickerView.extend
    dateBinding: 'controller.endsAt'
    leader: 'Ends:'

  location:  Radium.MapView.extend
    leader: 'location'

  userList: Ember.TextField.extend
    didInsertElement: ->
      retrieve = (query, callback) =>
        # FIXME: Change to real server query
        result = Radium.User.find().map (user) ->
          value: user.get('id')
          name: user.get('name')

        callback(result, query)

      @$().autoSuggest({retrieve: retrieve}, {selectedItemProp: "name", searchObjProps: "name"});
