require 'lib/radium/combobox'
require 'lib/radium/group_autocomplete'
Radium.HighlightInlineEditor = Radium.InlineEditorView.extend
  toggleEditor:  (evt) ->
    @_super.apply this, arguments

    return unless @get 'isEditing'
    Ember.run.scheduleOnce 'afterRender', this, 'highlightSelection'

  highlightSelection: ->
    @$('input[type=text],textarea').filter(':first').select()

Radium.ContactSidebarView = Radium.SidebarView.extend
  classNames: ['sidebar-panel-bordered']

  statuses: ( ->
    @get('controller.leadStatuses').map (status) ->
      Ember.Object.create
        name: status.name
        value: status.value
  ).property('controller.leadStatuses.[]')

  statusSelect: Ember.Select.extend
    contentBinding: 'parentView.statuses'
    optionValuePath: 'content.value'
    optionLabelPath: 'content.name'
    valueBinding: 'controller.status'

  contactInlineEditor: Radium.HighlightInlineEditor.extend
    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>
          {{input type="text" value=company.website class="field" placeholder="Company Website"}}
        </div>
        <div>&nbsp;</div>
      {{else}}
        <div class="not-editing">
          <a href="mailto:{{unbound company.website}}">{{company.website}}</a>
        </div>
        <div>
          <i class="icon-edit" {{action toggleEditor target=view bubbles=false}}></i>
        </div>
      {{/if}}
    """

  aboutInlineEditor: Radium.HighlightInlineEditor.extend
    template: Ember.Handlebars.compile """
      <div>
        {{#if view.isEditing}}
          <div>
            {{view Radium.TextArea class="field" valueBinding=view.value placeholder="About"}}
          </div>
        {{else}}
          <i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i>
          <div class="not-editing">
            <span>{{about}}</span>
          </div>
        {{/if}}
      </div>
    """

  groups: Radium.GroupAutoComplete.extend
    isEditableBinding: 'controller.isEditable'
