require 'lib/radium/autocomplete_combobox'
require 'lib/radium/value_validation_mixin'
require 'lib/radium/contact_company_picker'
require 'views/contact/contact_tag_autocomplete'

Radium.LeadsNewView = Ember.View.extend Radium.ContactViewMixin,
  actions:
    submit: ->
      @set 'controller.isSubmitted', true

      return unless @get('controller.isValid')

      if Ember.isEmpty( @get('controller.name')) || Ember.isEmpty( @get('controller.companyName'))
        @$('.modal').modal backdrop: false
        return

      @get('controller').send 'submit'

    showContactDetails: ->
      @$('.commit').show()
      contactDetails = @$('.contact-detail')
      existingArea = @$('.existing')

      existingArea.hide()
      contactDetails.slideDown('medium')

    toggleDetail: ->
      @$('.address-section').slideToggle('medium')
      @$('#detailToggle').toggleClass('ss-navigatedown ss-navigateup')

    showExistingDetails: ->
      @$('.commit').hide()
      @$('.contact-detail').slideToggle('medium')
      @$('#existingToggle').toggleClass('ss-navigateup')

    cancelSubmit: ->
      @$('.modal').modal 'hide'

      if Ember.isEmpty @get('controller.name')
        @$('.contact-name input[type=text]').focus()
        return

      @$('.company-name input[type=text]').focus()

  classNameBindings: ['controller.isNew::disabled-content']
  contacts: Ember.computed.alias 'controller.contacts'

  didInsertElement: ->
    @_super.apply this, arguments
    @$('.contact-name').focus()
    @$('.contact-detail').slideDown('medium') if @get('controller.expandImmediately')
    @get('controller').on('hideModal', this, 'onHideModal') if @get('controller').on

  onHideModal: ->
    @$('.modal').modal 'hide' if @$('.modal')

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
      @get('parentView').send('showContactDetails') unless @$('.contact-detail').is(':visible')

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
    valueBinding: 'targetObject.notes'
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
    @$('.radio-group input').attr('disabled', disabled)

    unless @get('controller.isNew')
      @$('.multiple-field .icon-plus').hide()

  ).observes('controller.isNew')

  contactName: Radium.ContactPicker.extend Radium.ContactCompanyMixin,
    classNameBindings: ['open', ':contact-name']
    valueBinding: 'controller.name'
    disabledBinding: 'parentView.disabled'
    placeholder: 'Type a name'
    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isNew: Ember.computed.alias 'controller.isNew'
    highlighter: (item) ->
      string = item.get 'displayName'

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
      @get('controller').send 'cancel'

    setValue: (searchResult) ->
      contact = searchResult.get('person')
      @set 'controller.model', contact
      @set 'value', contact.get('displayName')

    didInsertElement: ->
      @_super.apply this, arguments
      Ember.run =>
        @$('input[type=text]').val('')
        @$('input[type=text]').focus()

    blur: ->
      return unless @get('isNew')
      return if @get('value')?.length < 3
      @get('parentView').send('showContactDetails') unless @$('.contact-detail').is(':visible')
