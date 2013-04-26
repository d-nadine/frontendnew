require 'lib/radium/multiple_fields'
require 'lib/radium/multiple_field'
require 'lib/radium/phone_multiple_field'
require 'lib/radium/address_multiple_field'
require 'lib/radium/text_combobox'
require 'lib/radium/value_validation_mixin'
require 'lib/radium/group_autocomplete'

Radium.LeadsNewView = Ember.View.extend
  contacts: Ember.computed.alias 'controller.contacts'

  didInsertElement: ->
    @_super.apply this, arguments
    @$('.contact-name').focus()

  statusDescription: ( ->
    currentStatus = @get('controller.status')
    return "" unless currentStatus

    @get('controller.leadStatuses').find((status) ->
      status.value == currentStatus
    ).name
  ).property('controller.status')

  existingContactText: ( ->
    return if @get('controller.isNew')

    status = @get('controller.status')

    if status == "lead"
      return "is a lead.  Do you want to add a deal?"
    else if status == "existing"
      return "is an existing customer.  Do you want to add a deal?"

    "is not a lead, do you want to update their status to lead?"
  ).property('controller.isNew')

  submit: ->
    @set 'controller.isSubmitted', true

    return unless @get('controller.isValid')

    if Ember.isEmpty( @get('controller.name')) || Ember.isEmpty( @get('controller.companyName'))
      @set 'showModal', true
      Ember.run.next =>
        @$('.modal').addClass 'in'
      return

    @set 'showModal', false
    @$('.modal').removeClass 'in'

    @get('controller').submit()

  cancelSubmit: ->
    @$().one $.support.transition.end, =>
      @set 'showModal', false

    @$('.modal').removeClass('in')

    if Ember.isEmpty @get('controller.name')
      @$('.contact-name input[type=text]').focus()
      return

    @$('.company-name input[type=text]').focus()

  missingDetail: ( ->
    return "contact name" if Ember.isEmpty(@get('controller.name'))
    return "company" if Ember.isEmpty(@get('controller.companyName'))
  ).property('controller.name', 'controller.companyName', 'showModal')

  tags: Radium.TagAutoComplete.extend()

  companyPicker: Radium.TextCombobox.extend Radium.ContactCompanyMixin,
    classNameBindings: [':company-name']
    disabled: Ember.computed.not 'controller.isNew'
    sourceBinding: 'controller.companyNames'
    valueBinding: 'controller.companyName'
    placeholder: 'Company'
    blur: ->
      return unless @get('controller.isNew')
      return if @get('value')?.length < 3
      @get('parentView').showContactDetails() unless @$('.contact-detail').is(':visible')

  phoneNumbers: Radium.MultipleFields.extend
    labels: ['Mobile','Work','Home']
    leader: 'Phone'
    sourceBinding: 'controller.phoneNumbers'
    viewType: Radium.PhoneMultipleField
    type: Radium.PhoneNumber
    readonly: Ember.computed.not 'controller.isNew'
    canReset: true

  emailAddresses: Radium.MultipleFields.extend
    labels: ['Work','Home']
    isSubmitted: Ember.computed.alias 'controller.isSubmitted'
    inputType: 'email'
    leader: 'Email'
    sourceBinding: 'controller.emailAddresses'
    type: Radium.EmailAddress
    readonly: Ember.computed.not 'controller.isNew'
    canReset: true

  userPicker: Radium.UserPicker.extend Radium.ValueValidationMixin,
    disabled: Ember.computed.not 'controller.isNew'
    valueBinding: 'controller.model.assignedTo'

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

  notes: Radium.TextArea.extend
    attributeBindings: ['readonly']
    classNames: ['field', 'text-area']
    placeholder: 'What is the lead interested in buying?'
    valueBinding: 'controller.notes'
    readonly: Ember.computed.not 'controller.isNew'

  source: Radium.TextCombobox.extend Radium.ValueValidationMixin,
    classNameBindings: [
      'disabled:is-disabled'
    ]
    disabled: Ember.computed.not 'controller.isNew'
    sourceBinding: 'controller.leadSources'
    valueBinding: 'controller.source'
    placeholder: 'Where is this lead from?'
    valueBinding: 'controller.source'

  addresses: Radium.MultipleFields.extend
    labels: ['Office','Home']
    leader: 'Address'
    sourceBinding: 'controller.addresses'
    viewType: Radium.AddressMultipleField
    type: Radium.Address
    readonly: Ember.computed.not 'controller.isNew'
    canReset: true

  contactDidChange: ( ->
    contactDetails = @$('.contact-detail')
    existingArea = @$('.existing')

    return unless contactDetails && contactDetails.length > 0

    contactDetails.slideUp('medium', ->
      existingArea.slideDown('medium'))
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

  contactName: Radium.Combobox.extend Radium.ContactCompanyMixin,
    classNameBindings: ['open', ':contact-name']
    valueBinding: 'controller.name'
    disabledBinding: 'parentView.disabled'
    placeholder: 'Type a name'
    sourceBinding: 'controller.contacts'
    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isNew: Ember.computed.alias 'controller.isNew'
    lookupQuery: (query) ->
      @get('source').find (item) -> item.get('name') == query

    template: Ember.Handlebars.compile """
      <a {{action selectObject this target=view href=true bubbles=false}}>{{name}}{{contactSourceImage status class="img-polaroid"}}</a>
    """

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
        lookUp =  @lookupQuery(value)
        if lookUp
          @$('input[type=text]').blur()
          @clearValue()
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

    setValue: (object) ->
      @set 'value', object.get('name')
      @set 'controller.model', object

    didInsertElement: ->
      @_super.apply this, arguments
      @$('input[type=text]').focus()

    clearValue: ->
      @get('controller').cancel()

    blur: ->
      return unless @get('isNew')
      return if @get('value')?.length < 3
      @get('parentView').showContactDetails() unless @$('.contact-detail').is(':visible')
