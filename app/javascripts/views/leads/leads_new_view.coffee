require 'lib/radium/autocomplete_combobox'
require 'lib/radium/value_validation_mixin'
require 'lib/radium/contact_company_picker'
require 'views/contact/contact_tag_autocomplete'

Radium.LeadsNewView = Ember.View.extend Radium.ContactViewMixin,
  contacts: Ember.computed.alias 'controller.contacts'

  didInsertElement: ->
    @_super.apply this, arguments
    @$('.contact-name').focus()
    @$('.contact-detail').slideDown('medium') if @get('controller.expandImmediately')
    @get('controller').on('hideModal', this, 'onHideModal') if @get('controller').on

  onHideModal: ->
    @$('.modal').modal 'hide' if @$('.modal')

  submit: ->
    @set 'controller.isSubmitted', true

    return unless @get('controller.isValid')

    if Ember.isEmpty( @get('controller.name')) || Ember.isEmpty( @get('controller.companyName'))
      @$('.modal').modal backdrop: false
      return

    @get('controller').submit()

  cancelSubmit: ->
    @$('.modal').modal 'hide'

    if Ember.isEmpty @get('controller.name')
      @$('.contact-name input[type=text]').focus()
      return

    @$('.company-name input[type=text]').focus()

  missingDetail: ( ->
    return "contact name" if Ember.isEmpty(@get('controller.name'))
    return "company" if Ember.isEmpty(@get('controller.companyName'))
  ).property('controller.name', 'controller.companyName', 'showModal')

  tags: Radium.ContactTagAutocomplete.extend
    isEditableBinding: 'controller.isNew'

  companyPicker: Radium.ContactCompanyPicker.extend Radium.ContactCompanyMixin,
    disabled: Ember.computed.not 'controller.isNew'

    blur: ->
      return unless @get('controller.isNew')
      return if @get('controller.companyName')?.length < 3
      @get('parentView').showContactDetails() unless @$('.contact-detail').is(':visible')

  userPicker: Radium.UserPicker.extend Radium.ValueValidationMixin,
    disabled: Ember.computed.not 'controller.isNew'

  contactType: Ember.View.extend
    classNames: ['controls-group','radio-group']
    sourceBinding: 'controller.leadStatuses'
    template: Ember.Handlebars.compile """
      <ul>
      {{#each view.source}}
        {{view Radium.Radiobutton selectedValueBinding="controller.status" name="type" leaderBinding="name" valueBinding="value" tagName="li"}}
      {{/each}}
      </ul>
    """

  workflowStates: Ember.View.extend
    classNames: ['controls-group','radio-group']
    sourceBinding: 'controller.workflowStates'
    template: Ember.Handlebars.compile """
      <ul>
      {{#each view.source}}
        {{view Radium.Radiobutton selectedValueBinding="controller.dealState" name="dealState" leaderBinding="this" valueBinding="this" tagName="li"}}
      {{/each}}
      </ul>
    """

  notes: Radium.TextArea.extend
    attributeBindings: ['readonly']
    classNames: ['field', 'text-area']
    placeholder: 'What is the lead interested in buying?'
    valueBinding: 'controller.notes'
    readonly: Ember.computed.not 'controller.isNew'

  source: Radium.LeadSourcesView.extend
    disabled: Ember.computed.not 'controller.isNew'
    sourceBinding: 'controller.leadSources'

  contactDidChange: ( ->
    contactDetails = @$('.contact-detail')
    existingArea = @$('.existing')

    return unless contactDetails && contactDetails.length > 0

    contactDetails.slideUp('medium', ->
      existingArea.slideDown('medium'))

    disabled = if @get('controller.isNew') then false else true

    @$('.multiple-field input').attr('readonly', disabled)
    @$('.multiple-field select').attr('readonly', disabled)

    unless @get('controller.isNew')
      @$('.multiple-field .icon-plus').hide()

  ).observes('controller.isNew')

  showContactDetails: ->
    @$('.commit').show()
    contactDetails = @$('.contact-detail')
    existingArea = @$('.existing')

    existingArea.hide()
    contactDetails.slideDown('medium')

  toggleDetail: ->
    @$('.address-section').slideToggle('medium')
    @$('#detailToggle').toggleClass('icon-arrow-up icon-arrow-down')

  showExistingDetails: ->
    @$('.commit').hide()
    @$('.contact-detail').slideToggle('medium')
    @$('#existingToggle').toggleClass('icon-arrow-up icon-arrow-down')

  contactName: Radium.AutocompleteCombobox.extend Radium.ContactCompanyMixin,
    classNameBindings: ['open', ':contact-name']
    valueBinding: 'controller.name'
    disabledBinding: 'parentView.disabled'
    placeholder: 'Type a name'
    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isNew: Ember.computed.alias 'controller.isNew'
    autocompleteResultType: Radium.AutocompleteContact
    highlighter: (item) ->
      string = item.get 'name'

      query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
      result = string.replace new RegExp('(' + query + ')', 'ig'), ($1, match) ->
        "<strong>#{match}</strong>"

      # FIXME: determine image src from status
      url = "http://placehold.it/16x16"

      result += "<img src='#{url}' class='img-polaroid' alt=#{item.get('source')}/>"
      result

    queryToValueTransform: ((key, value) ->
      if arguments.length == 2
        if @matchesSelection(value)
          @$('input[type=text]').blur()
          @clearValue()
          @set 'controller.name', value
        else
          unless @get('isNew')
            @clearValue()
          @set 'value', value
      else if !value && @get('value')
        @get 'value'
      else
        value
    ).property('value')

    clearValue: ->
      @get('controller').cancel()

    setValue: (searchResult) ->
      contact = searchResult.get('contact')
      @set 'value', contact.get('name')
      @set 'controller.model', contact

    didInsertElement: ->
      @_super.apply this, arguments
      @$('input[type=text]').focus()

    clearValue: ->
      @get('controller').cancel()

    blur: ->
      return unless @get('isNew')
      return if @get('value')?.length < 3
      @get('parentView').showContactDetails() unless @$('.contact-detail').is(':visible')
