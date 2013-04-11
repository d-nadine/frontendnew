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

  # FIXME: refactor after agreement
  companyPicker: Ember.View.extend
    classNameBindings: [
      'isInvalid'
      'isValid'
      'disabled:is-disabled'
      ':combobox'
      ':control-box'
    ]
    sourceBinding: 'controller.companyNames'
    valueBinding: 'controller.companyName'
    queryBinding: 'queryToValueTransform'
    disabledBinding: 'parentView.disabled'
    placeholder: 'Company'
    isInvalid: ( ->
      return unless @get('controller.isSubmitted')

      Ember.isEmpty(@get('value'))
    ).property('value', 'controller.isSubmitted')

    isValid: (->
      value = @get 'value'
      return unless value
      true
    ).property('value')

    queryToValueTransform: ((key, value) ->
      if arguments.length == 2
        @set 'value', value
      else if !value && @get('value')
        @get 'value'
      else
        value
    ).property('value')

    template: Ember.Handlebars.compile """
      {{view view.textField}}

      {{#unless view.disabled}}
        <div {{bindAttr class="view.open:open :btn-group"}} {{action toggleDropdown target=view bubbles=false}}>
          <button class="btn dropdown-toggle" tabindex="-1">
            <i class="icon-arrow-down"></i>
          </button>
          <ul class="dropdown-menu">
            {{#each item in view.source}}
              <li><a {{action selectItem item target=view href=true bubbles=false}}>{{item}}</a></li>
            {{/each}}
          </ul>
        </div>
      {{/unless}}
    """

    textField: Ember.TextField.extend
      valueBinding: 'parentView.query'
      placeholderBinding: 'parentView.placeholder'
      disabledBinding: 'parentView.disabled'
      didInsertElement: ->
        @$().typeahead source: @get('parentView.source')

    toggleDropdown: (event) ->
      @toggleProperty 'open'

    selectItem: (text) ->
      @set 'open', false
      @set 'value', text

  phoneNumbers: Radium.MaskedMultipleFields.extend
    leader: 'Phone'
    type: 'text'
    sourceBinding: 'controller.phoneNumbers'
    mask: '+9? (9?99) 999-9999 x99999'

  emailAddresses: Radium.MultipleFields.extend
    isSubmitted: Ember.computed.alias 'controller.isSubmitted'
    type: 'email'
    leader: 'Email'
    sourceBinding: 'controller.emailAddresses'

  userPicker: Radium.UserPicker.extend
    classNameBindings: ['isValid',':field']
    disabledBinding: 'controller.isDisabled'
    valueBinding: 'controller.model.assignedTo'
    isValid: ( ->
      !!@get('controller.assignedTo')
    ).property('controller.assignedTo')

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
