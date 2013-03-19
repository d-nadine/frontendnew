require 'lib/radium/multiple_field'
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

  phoneNumbers: Radium.MultipleField.extend
    classNames: ['control-group']
    leader: 'Phone Number'
    sourceBinding: 'controller.phoneNumbers'

  emailAddresses: Radium.MultipleField.extend
    classNameBindings: [':control-group']
    isSubmitted: Ember.computed.alias 'controller.isSubmitted'
    type: 'email'
    leader: 'Email'
    sourceBinding: 'controller.emailAddresses'
    isInvalid: ( ->
      return false unless @get('isSubmitted')

      not @get('controller.emailAddresses').someProperty 'value'
    ).property('controller.emailAddresses.[]', 'isSubmitted')


  userPicker: Radium.UserPicker.extend
    disabledBinding: 'controller.isDisabled'
    valueBinding: 'controller.assignedTo'

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
    classNames: ['field', 'text-area','input-xxlarge']
    placeholder: 'What is the lead interested in buying?'
    valueBinding: 'controller.notes'
    didInsertElement: ->
      @_super()
      @$().elastic()

    willDestroyElement: ->
      @$().off('elastic')

  source: Ember.TextField.extend
    classNames: ['field', 'input-xxlarge']
    placeholder: 'Where is this lead from?'
    valueBinding: 'controller.source'

  addresses: Radium.MultipleField.extend
    classNames: ['control-group']
    leader: 'Address'
    sourceBinding: 'controller.addresses'
    template: Ember.Handlebars.compile """
      <div class="addresses">
        <div class="control-group">
          {{view Ember.TextField classNames="field input-xlarge" valueBinding="view.current.value.street" placeholderBinding="view.leader"}}
        </div>
        <div class="control-group">
          {{view Ember.TextField  valueBinding="view.current.value.city" classNames="field input-xlarge" placeholder="City"}}
        </div>
        <div class="control-group">
          {{view Ember.TextField valueBinding="view.current.value.state" classNames="field" placeholder="State" }}
          {{view Ember.TextField valueBinding="view.current.value.zipcode" classNames="field" placeholder="Zip code"}}
        </div>
      </div>
    """

  contactName: Radium.TypeaheadTextField.extend
    classNameBindings: ['isInvalid', ':field', ':input-xlarge']
    valueBinding: 'controller.name'
    disabledBinding: 'parentView.disabled'
    placeholder: 'Type a name'
    sourceBinding: 'controller.contacts'
    timeoutId: null
    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isExistingContact: Ember.computed.alias 'controller.isExistingContact'
    isNewContactBinding: 'controller.isNewContact'

    didInsertElement: ->
      @_super.apply this, arguments
      @$('input[type=text]').focus()

    setValue: (object) ->
      @set 'value', object
      @set 'controller.model', object

    timeoutId: null
    keyDown: (evt) ->
      return if @get('controller.isExistingContact') || @get('controller.isNewContact')

      timeoutId = @get('timeoutId')
      if timeoutId
        clearTimeout timeoutId

      timeoutId = setTimeout(( =>
        parentView = @get('parentView')
        value = @get('value')

        if parentView.get('value') || value?.length < 3
          parentView.set('controller.isNewContact', false)
          return

        parentView.set('controller.isNewContact', true)
      ), 800)
