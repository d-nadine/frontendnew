Radium.SidebarMeetingFormView = Radium.MeetingFormView.extend
  init: ->
    @_super.apply this, arguments
    @set 'controller', Radium.MeetingFormController.create()

  hide: ->
  close: ->
    @get('controller').setDefaults()

