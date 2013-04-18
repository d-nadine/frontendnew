require 'lib/radium/multiple_fields'
require 'lib/radium/multiple_field'
require 'lib/radium/phone_multiple_field'
require 'lib/radium/address_multiple_field'
require 'lib/radium/text_combobox'
require 'lib/radium/value_validation_mixin'

Radium.LeadsNewView = Ember.View.extend
  contacts: Ember.computed.alias 'controller.contacts'

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

  changeExisting: ->
    @set 'controller.existingDetailsShown', false
    @showContactDetails()
    @set 'changingStatus', true
    @set 'controller.status', 'lead'
    @set 'changingStatus', false

  companyPicker: Radium.TextCombobox.extend Radium.ValueValidationMixin,
    sourceBinding: 'controller.companyNames'
    valueBinding: 'controller.companyName'
    placeholder: 'Company'

  phoneNumbers: Radium.MultipleFields.extend
    labels: ['Mobile','Work','Home']
    leader: 'Phone'
    sourceBinding: 'controller.phoneNumbers'
    viewType: Radium.PhoneMultipleField
    type: Radium.PhoneNumber

  emailAddresses: Radium.MultipleFields.extend
    labels: ['Work','Home']
    isSubmitted: Ember.computed.alias 'controller.isSubmitted'
    inputType: 'email'
    leader: 'Email'
    sourceBinding: 'controller.emailAddresses'
    type: Radium.EmailAddress

  userPicker: Radium.UserPicker.extend Radium.ValueValidationMixin,
    disabledBinding: 'controller.isDisabled'
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

  notes: Ember.TextArea.extend
    classNames: ['field', 'text-area']
    placeholder: 'What is the lead interested in buying?'
    valueBinding: 'controller.notes'
    didInsertElement: ->
      @_super()
      @$().elastic()

    willDestroyElement: ->
      @$().off('elastic')

  source: Radium.TextCombobox.extend Radium.ValueValidationMixin,
    classNameBindings: [
      'disabled:is-disabled'
    ]
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

  contactDidChange: ( ->
    return if @get('changingStatus')

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

  showExistingDetails: ->
    @$('.commit').hide()
    @$('.contact-detail').slideToggle('medium')
    @$('#existingToggle').toggleClass('icon-arrow-up icon-arrow-down')

  contactName: Radium.Combobox.extend Radium.ValueValidationMixin,
    classNameBindings: ['open']
    valueBinding: 'controller.name'
    disabledBinding: 'parentView.disabled'
    placeholder: 'Type a name'
    sourceBinding: 'controller.contacts'
    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isNew: Ember.computed.alias 'controller.isNew'
    lookupQuery: (query) ->
      @get('source').find (item) -> item.get('name') == query

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
      return if @get('value')?.length < 3
      @get('parentView').showContactDetails() unless @$('.contact-detail').is(':visible')
