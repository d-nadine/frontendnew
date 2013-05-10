Radium.StatusInlineEditorView = Radium.InlineEditorView.extend
  isValid: true
  statusesBinding: 'controller.controllers.leadStatuses.statuses'
  statusDescriptionBinding: 'parentView.statusDescription'
  statusSelect: Ember.Select.extend
    contentBinding: 'parentView.statuses'
    optionValuePath: 'content.value'
    optionLabelPath: 'content.name'
    valueBinding: 'controller.status'

  template: Ember.Handlebars.compile """
    {{#if view.isEditing}}
      <div>{{view view.statusSelect}}</div>
      <div>&nbsp;</div>
    {{else}}
      <div>
        <h2>{{view.statusDescription}}</h2>
      </div>
      <div>
        <i class="icon-edit" {{action toggleEditor target=view bubbles=false}}></i>
      </div>
    {{/if}}
  """
