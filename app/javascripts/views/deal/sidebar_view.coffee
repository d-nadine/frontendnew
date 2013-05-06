require 'lib/radium/user_picker'

Radium.DealSidebarView = Radium.View.extend
  userInlineEditor: Radium.InlineEditorView.extend
    activateOnClick: false

    userPicker: Radium.UserPicker.extend
      isSubmitted: true
