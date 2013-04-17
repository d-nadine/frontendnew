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
    return unless @get('controller.isExistingContact')

    status = @get('controller.status')

    if status == "lead"
      return "is a lead.  Do you want to add a deal?"
    else if status == "existing"
      return "is an existing customer.  Do you want to add a deal?"

    "is not a lead, do you want to update their status to lead?"
  ).property('controller.isExistingContact')

  companyPicker: Radium.TextCombobox.extend Radium.ValueValidationMixin,
    sourceBinding: 'controller.companyNames'
    valueBinding: 'controller.companyName'
    placeholder: 'Company'

  phoneNumbers: Radium.MultipleFields.extend
    leader: 'Phone'
    type: 'text'
    sourceBinding: 'controller.phoneNumbers'
    viewType: Radium.PhoneMultipleField

  emailAddresses: Radium.MultipleFields.extend
    isSubmitted: Ember.computed.alias 'controller.isSubmitted'
    type: 'email'
    leader: 'Email'
    sourceBinding: 'controller.emailAddresses'

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
    leader: 'Address'
    sourceBinding: 'controller.addresses'
    viewType: Radium.AddressMultipleField

  contactDidChange: ( ->
    newContactArea = @$('.new-contact')
    existingArea = @$('.existing')

    return unless newContactArea && newContactArea.length > 0

    existingArea.hide()

    if @get('controller.isNewContact') || @get('controller.showExisting')
      newContactArea.slideDown('medium')
    else
      newContactArea.slideUp('medium')
  ).observes('controller.isNewContact','controller.showExisting')

  isExistingContactDidChange: ( ->
    newContactArea = @$('.new-contact')
    existingArea = @$('.existing')

    return unless existingArea && existingArea.length > 0

    newContactArea.hide()

    if @get('controller.isExistingContact')
      existingArea.slideDown('medium')
    else
      existingArea.slideUp('medium')
  ).observes('controller.isExistingContact')

  showExistingDetails: ->
    newContactArea = @$('.new-contact')

    return unless newContactArea && newContactArea.length > 0

    newContactArea.slideToggle('medium')
    @toggleProperty 'controller.existingDetailsShown'

  showDetailDidChange: ( ->
    addressArea = @$('.address-section')

    return unless addressArea && addressArea.length > 0

    addressArea.slideToggle('medium')

    @$('.showdetails-link i').toggleClass('icon-arrow-down icon-arrow-up')
  ).observes('controller.showDetail')

  contactName: Radium.Combobox.extend Radium.ValueValidationMixin,
    classNameBindings: ['open']
    valueBinding: 'controller.name'
    disabledBinding: 'parentView.disabled'
    placeholder: 'Type a name'
    sourceBinding: 'controller.contacts'
    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isExistingContact: Ember.computed.alias 'controller.isExistingContact'
    isNewContactBinding: 'controller.isNewContact'
    queryToValueTransform: ((key, value) ->
      if arguments.length == 2
        lookup = @lookupQuery(value)
        if lookup
          @set 'value', @lookupQuery(value)
          return

        unless @get('isExistingContact')
          @set 'value', value
      else if !value && @get('value')
        @get 'value.name'
      else
        value
    ).property('value')

    didInsertElement: ->
      @_super.apply this, arguments
      @$('input[type=text]').focus()

    clearValue: ->
      @get('controller').cancel()

    blur: ->
      return if @get('isExistingContact') || @get('isNewContact')
      return if @get('value')?.length < 3
      @set('isNewContact', true)
