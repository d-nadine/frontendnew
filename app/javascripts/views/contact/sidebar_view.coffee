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

  aboutInlineEditor: Radium.AboutInlineEditor.extend()

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
