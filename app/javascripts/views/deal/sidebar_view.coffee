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
      leader: ''

    template: Ember.Handlebars.compile """
      <h2>Assigned To</h2>

      <div class="assigned-to">
        {{#with view.value}}
          {{#if view.isEditing}}
            {{#linkTo user this}}
              {{avatar this class="img-polaroid"}}
            {{/linkTo}}
            {{view view.userPicker class="field"}}
          {{else}}
            <i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i>
            {{#linkTo user this}}
              {{avatar this class="img-polaroid"}}
            {{/linkTo}}

            <p>
              {{#linkTo user this}}{{name}}{{/linkTo}}<br/>
              <span class="title muted">{{title}}</span>
            </p>
          {{/if}}
        {{/with}}
      </div>
    """

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

