Radium.UserInlineEditor = Radium.InlineEditorView.extend
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
