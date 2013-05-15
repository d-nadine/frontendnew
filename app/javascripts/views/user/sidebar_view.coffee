require 'lib/radium/combobox'
require 'lib/radium/text_combobox'
require 'lib/radium/multiple_fields'
require 'lib/radium/multiple_field'
require 'lib/radium/phone_multiple_field'
require 'lib/radium/address_multiple_field'
require 'lib/radium/phone_input'
requireAll /views\/sidebar/

Radium.UserSidebarView = Radium.View.extend
  headerInlineEditor: Radium.InlineEditorView.extend
    isValid: true

    template: Ember.Handlebars.compile """
      {{#if view.isEditing}} 
        <div class="contact-detail">
          <div class="control-group">
            <label class="control-label">First Name</label>
            <div class="controls">
              {{input value=firstName class="field detail" placeholder="First Name"}}
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Surname</label>
            <div class="controls">
              {{input value=lastName class="field detail" placeholder="Surname"}}
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Title</label>
            <div class="controls">
              {{input value=title class="field detail" placeholder="Title"}}
            </div>
          </div>
        </div>
      {{else}}
        {{avatar this size=medium class="img-polaroid"}}
        <div class="header">
          <div>
            <div>
              <span class="name">{{name}}</span>
            </div>
            <div>
              <i class="icon-edit" {{action toggleEditor target=view bubbles=false}}></i>
            </div>
          </div>
        </div>
        <div class="title">
          <span class="title muted">{{title}}</span>
        </div>
      {{/if}}
    """

  emailInlineEditor: Radium.InlineEditorView.extend
    valueBinding: 'controller.email'
    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        {{input type="email" value=view.value class="field"}}
      {{else}}
        <div class="control-group">
          </id><label class="control-label"><i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></label>
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
