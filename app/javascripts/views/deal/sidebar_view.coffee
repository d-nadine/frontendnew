require 'lib/radium/user_picker'

Radium.DealSidebarView = Radium.SidebarView.extend
  elementId: ['deal-sidebar-panel']
  classNames: ['sidebar-panel-bordered']

  userInlineEditor: Radium.InlineEditorView.extend
    activateOnClick: false

    userPicker: Radium.UserPicker.extend
      isSubmitted: true
