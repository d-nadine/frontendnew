require 'lib/radium/combobox'
require 'lib/radium/text_combobox'
require 'lib/radium/multiple_fields'
require 'lib/radium/multiple_field'
require 'lib/radium/phone_multiple_field'
require 'lib/radium/address_multiple_field'
require 'lib/radium/user_picker'
require 'lib/radium/company_picker'

Radium.CompanySidebarView = Radium.View.extend
  companyInlineEditor: Radium.InlineEditorView.extend
    valueBinding: 'controller.name'

  websiteInlineEditor: Radium.InlineEditorView.extend
    valueBinding: 'controller.website'
    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>
          {{input type="text" value=view.value class="field" placeholder="Add company website"}}
        </div>
      {{else}}
        <div class="not-editing">
          {{#if website}}
            <a href="{{unbound view.value}}" target="_blank"><i class="icon-cloud"></i>{{view.value}}</a>
          {{else}}
            <span class="empty">Add company website</span>
          {{/if}}
        </div>
        <div class="edit">
          <i class="icon-edit" {{action toggleEditor target=view bubbles=false}}></i>
        </div>
      {{/if}}
    """
