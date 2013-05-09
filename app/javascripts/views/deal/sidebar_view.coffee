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

  dealStatusInlineEditor: Radium.HighlightInlineEditor.extend
    statusSelect: Ember.Select.extend
      contentBinding: 'controller.statuses'
      valueBinding: 'controller.status'
      disabledBinding: 'controller.statusDisabled'

    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>{{view view.statusSelect}}</div>
      {{else}}
        <div>
          <h2>{{status}}</h2>
        </div>
        <div class="status-icon">
          <i class="icon-edit" {{action toggleEditor target=view bubbles=false}}></i>
        </div>
      {{/if}}
    """

