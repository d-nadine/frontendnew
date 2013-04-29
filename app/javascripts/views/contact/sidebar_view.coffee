require 'lib/radium/combobox'
require 'lib/radium/group_autocomplete'
require 'lib/radium/text_combobox'

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

  headerInlineEditor: Radium.HighlightInlineEditor.extend
    companyPicker: Radium.TextCombobox.extend
      classNameBindings: [':company-name']
      sourceBinding: 'controller.companyNames'
      valueBinding: 'controller.companyName'
      placeholder: 'Company'

    click: (evt) ->
      console.log evt.target.tagName

      unless evt.target.tagName.toLowerCase() == 'input'
        @_super.apply this, arguments
        return

      evt.preventDefault()
      evt.stopPropagation()

    isValid: true

    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div class="contact-detail">
          <div class="control-group">
            <label class="control-label">Name</label>
            <div class="controls">
              {{input value=name class="field detail" placeholder="Name"}}
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Title</label>
            <div class="controls">
              {{input value=title class="field detail" placeholder="Title"}}
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Company</label>
            <div class="controls">
              {{view view.companyPicker class="field"}}
            </div>
          </div>
        </div>
      {{else}}
        {{avatar this size=medium class="img-polaroid"}}
         <div class="header">
            <div>
              <div>
                <span class="type muted">contact</span>
              </div>
              <div>
                <i class="icon-edit"></i>
              </div>
            </div>
          </div>
          <div class="name">{{name}}</div>
          <div>
            <span class="title muted">{{title}}</span>
            <span class="company">
              {{#if company}}
                {{#linkTo unimplemented}}{{companyName}}{{/linkTo}}
              {{/if}}
            </span>
          </div>
      {{/if}}
    """

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
