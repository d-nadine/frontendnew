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
            {{#linkTo user this}}
              {{avatar this class="img-polaroid"}}
            {{/linkTo}}

            <p>
              {{#linkTo user this}}{{name}}{{/linkTo}}<br/>
              <span class="title muted">{{title}}</span>
              <i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i>
            </p>
          {{/if}}
        {{/with}}
      </div>
    """

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

