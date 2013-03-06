Radium.DealSidebarView = Radium.SidebarView.extend
  elementId: ['deal-sidebar-panel']
  classNames: ['sidebar-panel-bordered']

  amountInlineEditor: Radium.InlineEditorView.extend
    valueBinding: 'controller.value'

    template: Ember.Handlebars.compile """
      <div {{bindAttr class="view.isEditing:inline-editor-open:inline-editor-closed :inline-editor :amount"}}>
        {{#if view.isEditing}}
          <div {{bindAttr class="view.isValid:success:error :control-group"}}>
            <div class="input-prepend">
              <span class="add-on">$</span>
              {{view view.textField valueBinding=view.value class="span2" type="number" min="0"}}
            </div>
          </div>
        {{else}}
          <span class="text-success inline-editor-text">
            {{currency view.value}}
          </span>
        {{/if}}
      </div>
    """
