require 'radium/controllers/meeting_form_controller'

Radium.SidebarMeetingFormView = Radium.MeetingFormView.extend
  init: ->
    @_super.apply this, arguments
    @set 'controller', Radium.MeetingFormController.create()

  hide: ->
  close: ->
    @get('controller').setDefaults()

