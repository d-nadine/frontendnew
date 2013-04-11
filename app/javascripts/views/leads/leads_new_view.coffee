require 'lib/radium/multiple_fields'
require 'lib/radium/multiple_field'
require 'lib/radium/masked_multiple_field'
require 'lib/radium/masked_multiple_fields'
require 'lib/radium/address_multiple_field'
require 'lib/radium/typeahead_textfield'

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

  companyPicker: Radium.Combobox.extend
    valueBinding: 'controller.company'
    sourceBinding: 'controller.controllers.companies'
    disabledBinding: 'controller.isExistingContact'
    placeholder: 'Company'
    lookupQuery: (query) ->
      @get('source').find (item) -> item.get('name') == query

  phoneNumbers: Radium.MaskedMultipleFields.extend
    leader: 'Phone'
    type: 'text'
    sourceBinding: 'controller.phoneNumbers'
    mask: '+9? (9?99) 999-9999 x99999'

  emailAddresses: Radium.MultipleFields.extend
    classNameBindings: ['isInvalid']
    isSubmitted: Ember.computed.alias 'controller.isSubmitted'
    type: 'email'
    leader: 'Email'
    sourceBinding: 'controller.emailAddresses'
    isInvalid: ( ->
      return unless @get('controller.isSubmitted')
      return unless @get('controller.isNew')

      not @get('controller.emailAddresses').someProperty('value')
    ).property('controller.isSubmitted','controller.emailAddresses.@each.value')

  userPicker: Radium.UserPicker.extend
    classNameBindings: [':field']
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

  source: Ember.TextField.extend
    classNames: ['field']
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

  contactName: Radium.TypeaheadTextField.extend
    classNameBindings: ['isInvalid', 'open', ':field']
    valueBinding: 'controller.name'
    disabledBinding: 'parentView.disabled'
    placeholder: 'Type a name'
    sourceBinding: 'controller.contacts'
    timeoutId: null
    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isExistingContact: Ember.computed.alias 'controller.isExistingContact'
    isNewContactBinding: 'controller.isNewContact'

    isInvalid: ( ->
      return unless @get('controller.isSubmitted')

      Ember.isEmpty(@get('value'))
    ).property('value', 'controller.isSubmitted')

    didInsertElement: ->
      @_super.apply this, arguments
      @$('input[type=text]').focus()

    clearValue: ->
      @get('controller').cancel()

    setValue: (object) ->
      @set 'value', object.get('name')
      @set 'controller.model', object

    blur: ->
      return if @get('isExistingContact') || @get('isNewContact')
      return if @get('value')?.length < 3
      @set('isNewContact', true)
