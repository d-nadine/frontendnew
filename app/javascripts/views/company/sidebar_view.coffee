require 'lib/radium/combobox'
require 'lib/radium/text_combobox'
require 'lib/radium/multiple_fields'
require 'lib/radium/multiple_field'
require 'lib/radium/phone_multiple_field'
require 'lib/radium/address_multiple_field'
require 'lib/radium/user_picker'
require 'lib/radium/company_picker'
require 'lib/radium/tag_autocomplete'
require 'views/contact/contact_view_mixin'
requireAll /views\/sidebar/

Radium.CompanySidebarView = Radium.View.extend  Radium.ContactViewMixin,
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

  cancelChangeStatus: ->
    @get('statusChange').cancelChange()

  changeStatus: ->
    @$('.modal').modal 'hide'
    @get('controller').changeStatus()
    @get('statusChange').toggleEditor()

  statusInlineEditor: Radium.StatusInlineEditorView.extend
    init: ->
      @_super.apply this, arguments
      Ember.run.scheduleOnce 'afterRender', this, 'addStatusBeforeObserver'

    addStatusBeforeObserver: ->
      Ember.addBeforeObserver this, 'controller.status', this, 'statusWillChange'
      Ember.addObserver this, 'controller.status', this, 'statusDidChange'

    statusWillChange: (obj, key) ->
      @set('previousStatus', @get('controller.status'))

    cancelChange: ->
      @get('controller.transaction').rollback()
      @toggleEditor()
      @get('parentView').$('.modal').modal 'hide'

    destroy: ->
      Ember.removeBeforeObserver this, 'controller.status', this, 'statusWillChange'
      Ember.removeObserver this, 'controller.status', this, 'statusDidChange'

    statusDidChange: ->
      previous = @get('previousStatus')
      current = @get('controller.status')

      return if previous == current

      @get('parentView').$('.modal').modal backdrop: false

  tags: Radium.TagAutoComplete.extend()

  aboutInlineEditor: Radium.AboutInlineEditor.extend()

  userInlineEditor: Radium.UserInlineEditor.extend()

  addressInlineEditor: Radium.AddressInlineEditor.extend()
