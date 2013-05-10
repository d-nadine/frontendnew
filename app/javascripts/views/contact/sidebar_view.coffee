require 'lib/radium/combobox'
require 'lib/radium/text_combobox'
require 'lib/radium/multiple_fields'
require 'lib/radium/multiple_field'
require 'lib/radium/phone_multiple_field'
require 'lib/radium/address_multiple_field'
require 'lib/radium/user_picker'
require 'views/contact/contact_view_mixin'
require 'lib/radium/contact_company_picker'
require 'views/contact/contact_tag_autocomplete'
requireAll /views\/sidebar/

Radium.ContactSidebarView = Radium.View.extend Radium.ContactViewMixin,
  classNames: ['sidebar-panel-bordered']

  tags: Radium.ContactTagAutocomplete.extend
    onlyOnNew: false

  showExtraContactDetail: ->
    @$('.additional-detail').slideToggle('medium')
    @$('#existingToggle').toggleClass('icon-arrow-up icon-arrow-down')

  headerInlineEditor: Radium.InlineEditorView.extend
    isValid: true
    companyPicker: Radium.ContactCompanyPicker.extend()

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
              <span class="name">{{name}}</span>
            </div>
            <div>
              <i class="icon-edit" {{action toggleEditor target=view bubbles=false}}></i>
            </div>
          </div>
        </div>
        <div class="company-title">
          <span class="title muted">{{title}}</span>
          <span class="company">
            {{#if company}}
              {{#linkTo company company}}{{company.name}}{{/linkTo}}
            {{else}}
              {{companyName}}
            {{/if}}
          </span>
        </div>
      {{/if}}
    """

  contactStatusInlineEditor: Radium.StatusInlineEditorView.extend()

  contactInlineEditor: Radium.InlineEditorView.extend
    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>
          <i class="icon-cloud"></i>{{input type="text" value=company.website class="field" placeholder="Add company website"}}
        </div>
      {{else}}
        <div class="not-editing">
          {{#if company.website}}
            <a href="{{unbound company.website}}" target="_blank"><i class="icon-cloud"></i>{{company.website}}</a>
          {{else}}
            <span class="empty">Add company website</span>
          {{/if}}
        </div>
        <div>
          <i class="icon-edit" {{action toggleEditor target=view bubbles=false}}></i>
        </div>
      {{/if}}
    """

  emailAddressInlineEditor: Radium.InlineEditorView.extend
    isValid: true
    emailAddresses: Radium.MultipleFields.extend
      labels: ['Work','Home']
      inputType: 'email'
      leader: 'Email'
      sourceBinding: 'controller.emailAddresses'
      type: Radium.EmailAddress
      canReset: false

    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>
          {{view view.emailAddresses}}
        </div>
      {{else}}
        <div class="control-group">
          </id><label class="control-label primary-item"><i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></label>
          {{#if primaryEmail.value}}
            {{#linkTo emails.mailTo this}}<i class="icon-mail"></i>{{primaryEmail.value}}{{/linkTo}}
          {{else}}
            <span class="empty">Add email here</span>
          {{/if}}
        </div>
      {{/if}}
    """

  phoneInlineEditor: Radium.InlineEditorView.extend
    isValid: true
    phoneNumbers: Radium.MultipleFields.extend
      labels: ['Mobile','Work','Home']
      leader: 'Phone'
      sourceBinding: 'controller.phoneNumbers'
      viewType: Radium.PhoneMultipleField
      type: Radium.PhoneNumber
      canReset: false

    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>
          {{view view.phoneNumbers}}
        </div>
      {{else}}
        <div class="control-group">
          <label class="control-label primary-item"><i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></label>
          <div class="phone-section">
          <div>
            {{#if primaryPhone.value}}
              <a href="tel:{{unbound primaryPhone.value}}"><i class="icon-call"></i>{{primaryPhone.value}}</a>
            {{else}}
              <span class="empty">Add phone number here</span>
            {{/if}}
          </div>
          {{#if primaryPhone.value}}
            <div>
              <button class="btn btn-success">
                <i class="icon-call"></i>
              </button>
            </div>
          {{/if}}
          </div>
        </div>
      {{/if}}
    """

  aboutInlineEditor: Radium.AboutInlineEditor.extend()

  addressInlineEditor: Radium.AddressInlineEditor.extend()

  assignedToInlineEditor: Radium.InlineEditorView.extend
    isValid: true
    userPicker: Radium.UserPicker.extend
      isSubmitted: true
    template: Ember.Handlebars.compile """
      <div>
        {{#if view.isEditing}}
          <h2>Assigned To</h2>
          <div>
            {{view view.userPicker}}
          </div>
          <div class="source">
            <label class="control-label">Source</label>
            {{view Radium.LeadSourcesView}}
          </div>
        {{else}}
          <h2>Assigned To <i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></h2>
          {{#linkTo user user}}
            {{avatar user class="img-polaroid"}}
          {{/linkTo}}
          <p>
            {{#linkTo user user}}{{user.name}}{{/linkTo}}<br/>
            <span class="title muted">{{title}}</span>
          </p>
          <div class="source">
            <div>
              <div><label class="control-label">Source</label></div>
              <div>{{source}}</div>
            </div>
          </div>
        {{/if}}
        <div class="createdAt">
          <div>
            <div><label class="control-label">Client Since</label></div>
            <div>{{formatDateTime createdAt format="date"}}</div>
          </div>
        </div>
      </div>
    """
