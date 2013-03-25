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

  phoneNumbers: Radium.MultipleFields.extend
    leader: 'Phone'
    type: 'text'
    sourceBinding: 'controller.phoneNumbers'

  emailAddresses: Radium.MultipleFields.extend
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

  addresses: Radium.MultipleField.extend
    classNames: ['control-group']
    leader: 'Address'
    sourceBinding: 'controller.addresses'
    template: Ember.Handlebars.compile """
      <div class="addresses">
        <div class="control-group whole">
          {{view Ember.TextField classNames="field input-xlarge" valueBinding="view.current.value.street" placeholderBinding="view.leader"}}
        </div>
        <div class="control-group whole">
          {{view Ember.TextField  valueBinding="view.current.value.city" classNames="field input-xlarge city" placeholder="City"}}
        </div>
        <div class="control-group broken">
          {{view Ember.TextField valueBinding="view.current.value.state" classNames="field state" placeholder="State" }}
          {{view Ember.TextField valueBinding="view.current.value.zipcode" classNames="field zip" placeholder="Zip code"}}
        </div>
      </div>
    """

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

    didInsertElement: ->
      @_super.apply this, arguments
      @$('input[type=text]').focus()

    clearValue: ->
      @get('controller').cancel()

    setValue: (object) ->
      @set 'value', object.get('name')
      @set 'controller.model', object

    timeoutId: null

    keyPress: (evt) ->
      return if $('ul.typeahead:visible').length

      return if @get('isExistingContact') || @get('isNewContact')

      timeoutId = @get('timeoutId')
      if timeoutId
        clearTimeout timeoutId

      timeoutId = setTimeout(( =>
        value = @$('input[type=text]').val()

        if value?.length < 3
          @set('isNewContact', false)

          return

        @set('isNewContact', true)
      ), 800)
