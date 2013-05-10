require 'lib/radium/user_picker'
require 'views/sidebar/user_inline_editor'

Radium.DealSidebarView = Radium.View.extend
  contactInlineEditor: Radium.InlineEditorView.extend
    contactPicker: Radium.Combobox.extend
      classNameBindings: [':contact-picker']
      sourceBinding: 'controller.controllers.contacts'
      valueBinding: 'controller.contact'
      placeholder: 'Choose a contact'
      isSubmitted: true

  userInlineEditor: Radium.UserInlineEditor.extend()

  dealStatusInlineEditor: Radium.InlineEditorView.extend
    isValid: true
    statusSelect: Ember.Select.extend
      contentBinding: 'controller.statuses'
      valueBinding: 'controller.status'
      disabledBinding: 'controller.statusDisabled'

    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>{{view view.statusSelect class="status-select"}}</div>
      {{else}}
        <div class="deal-status">
          <h2>{{status}}<i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></h1>
        </div>
      {{/if}}
    """

