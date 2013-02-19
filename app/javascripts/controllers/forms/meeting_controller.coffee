Radium.FormsMeetingController = Radium.FormsBaseController.extend
  calendarsOpen: false

  showCalendars: ->
    @toggleProperty 'calendarsOpen'
    false
