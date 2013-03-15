require 'lib/radium/multiple_field'

Radium.LeadsNewView = Ember.View.extend
  contacts: Ember.computed.alias 'controller.contacts'
  contactExists: Ember.computed.bool 'value'
  valueBinding: 'controller.selectedContact'
  isNewLeadBinding: 'controller.isNewLead'

  didInsertElement: ->
    @$('.name').focus()

  phoneNumbers: Radium.MultipleField.extend
    classNames: ['control-group']
    leader: 'Phone Number'
    sourceBinding: 'controller.phoneNumbers'

  emailAddresses: Radium.MultipleField.extend
    classNames: ['control-group']
    leader: 'Email'
    sourceBinding: 'controller.emailAddresses'

  userPicker: Radium.UserPicker.extend
    disabledBinding: 'controller.isDisabled'
    valueBinding: 'controller.assignedTo'

  contactType: Ember.View.extend
    classNames: ['controls-group','radio-group']
    sourceBinding: 'controller.leadStatus'
    template: Ember.Handlebars.compile """
      <ul>
      {{#each view.source}}
        {{view Radium.Radiobutton selectedValueBinding="controller.status" name="type" leaderBinding="name" valueBinding="value" tagName="li"}}
      {{/each}}
      </ul>
    """

  notes: Ember.TextArea.extend
    classNames: ['field', 'text-area','input-xxlarge']
    placeholder: 'What is the lead interested in buying'
    valueBinding: 'controller.notes'
    didInsertElement: ->
      @_super()
      @$().elastic()

    willDestroyElement: ->
      @$().off('elastic')

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

  existingContactChecker: Radium.Typeahead.extend
    classNames: ['field', 'input-xlarge', 'name']
    valueBinding: 'parentView.query'
    disabledBinding: 'parentView.disabled'
    placeholderBinding: 'parentView.placeholder'
    sourceBinding: 'controller.contacts'
    timeoutId: null
    keyDown: (evt) ->
      timeoutId = @get('timeoutId')
      if timeoutId
        clearTimeout timeoutId

      timeoutId = setTimeout(( =>
        parentView = @get('parentView')
        value = @get('value')

        if parentView.get('value') || value?.length < 3
          parentView.set('isNewLead', false)
          return

        parentView.set('isNewLead', true)
      ), 800)

  setValue: (object) ->
    @set 'isNewLead', false
    @set 'value', object

  queryBinding: 'queryToValueTransform'

  lookupQuery: (query) ->
    @get('contacts').find (item) -> item.get('name') == query

  queryToValueTransform: ((key, value) ->
    if arguments.length == 2
      @set 'value', @lookupQuery(value)
    else if !value && @get('value')
      @get 'value.name'
    else
      value
  ).property('value')
