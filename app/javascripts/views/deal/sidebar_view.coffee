require 'lib/radium/user_picker'

Radium.DealSidebarView = Radium.SidebarView.extend
  classNames: ['sidebar-panel-bordered']

  userInlineEditor: Radium.InlineEditorView.extend
    activateOnClick: false

    userPicker: Radium.UserPicker.extend
      isSubmitted: true
