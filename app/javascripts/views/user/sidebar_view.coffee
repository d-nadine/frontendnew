require 'lib/radium/combobox'
require 'lib/radium/text_combobox'
require 'lib/radium/phone_input'
requireAll /views\/sidebar/

Radium.UserSidebarView = Radium.View.extend
  emailInlineEditor: Radium.InlineEditorView.extend
    valueBinding: 'controller.email'
    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        {{input type="email" value=view.value class="field"}}
      {{else}}
        <div class="control-group">
          <label class="control-label"><i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></label>
          {{#if email}}
            {{#linkTo emails.mailTo this}}<i class="icon-mail"></i>{{email}}{{/linkTo}}
          {{else}}
            <span class="empty">Add email here</span>
          {{/if}}
        </div>
      {{/if}}
    """

  phoneInlineEditor: Radium.InlineEditorView.extend
    valueBinding: 'controller.phone'
    isValid: true
    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        {{view Radium.PhoneInput valueBinding=view.value viewName="phone" isInvalid=false}}
      {{else}}
        <div class="control-group">
          </id><label class="control-label"><i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></label>
          {{#if phone}}
              <a href="tel:{{unbound phone}}"><i class="icon-call"></i>{{phone}}</a>
          {{else}}
            <span class="empty">Add phone here</span>
          {{/if}}
        </div>
      {{/if}}
    """
