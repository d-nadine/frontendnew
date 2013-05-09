require 'lib/radium/user_picker'

Radium.DealSidebarView = Radium.View.extend
  contactInlineEditor: Radium.InlineEditorView.extend
    contactPicker: Radium.Combobox.extend
      classNameBindings: [':contact-picker']
      sourceBinding: 'controller.controllers.contacts'
      valueBinding: 'controller.contact'
      placeholder: 'Choose a contact'
      isSubmitted: true

  userInlineEditor: Radium.InlineEditorView.extend
    activateOnClick: true

    userPicker: Radium.UserPicker.extend
      isSubmitted: true
