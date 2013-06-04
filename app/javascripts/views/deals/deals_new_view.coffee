require 'lib/radium/progress_bar'
require 'lib/radium/radio'
require 'lib/radium/text_combobox'
require 'lib/radium/value_validation_mixin'

Radium.DealsNewView= Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  showChecklistItems: false
  showDetail: false
  disabled: false

  toggleChecklist: (evt) ->
    return if @get('disabled')

    @$('.checklist-items-container').slideToggle('medium')
    @toggleProperty 'showChecklistItems'

  toggleDetail: (evt) ->
    @$('#deal-detail').slideToggle('medium')
    @toggleProperty 'showDetail'

  name: Ember.TextField.extend Radium.ValueValidationMixin,
    valueBinding: 'controller.name'
    disabledBinding: 'parentView.disabled'
    didInsertElement: ->
      @$().focus()

  contactPicker: Radium.Combobox.extend Radium.ValueValidationMixin,
    field: 'nameWithCompany'
    sourceBinding: 'controller.contacts'
    valueBinding: 'controller.contact'
    template: Ember.Handlebars.compile """
      <a {{action selectObject this target=view href=true bubbles=false}}>{{nameWithCompany}}</a>
    """

  userPicker: Radium.UserPicker.extend Radium.ValueValidationMixin,
    disabledBinding: 'parentView.disabled'
    leader: null

  description: Radium.TextArea.extend Radium.ValueValidationMixin,
    disabledBinding: 'parentView.disabled'
    rows: 3
    valueBinding: 'controller.description'

  dealStates: Ember.View.extend
    template: Ember.Handlebars.compile """
      <ul>
      {{#each controller.statuses}}
        {{view Radium.Radiobutton selectedValueBinding="controller.status" name="type" leaderBinding="this" valueBinding="this" tagName="li"}}
      {{/each}}
      </ul>
    """

  dealValue: Ember.View.extend
    classNameBindings: ['isValid','isInvalid', 'valueInvalid', ':deal-value', ':field', ':control-box']

    template: Ember.Handlebars.compile """
      <span  class="text dollar">$</span>
      {{input value=controller.value type="number" class="field input-medium negotitating"}}
      {{#if view.valueInvalid}}
        <span class="error"><i class="icon-warning icon-white"></i>Value must be greater than 0.</span>
      {{/if}}
    """

    valueInvalid: ( ->
      return false unless @get('controller.isSubmitted')
      value = @get('controller.value')

      return true if Ember.isEmpty value

      parseInt(value) == 0
    ).property('controller.value', 'controller.isSubmitted')

    isValid: ( ->
      value = @get('controller.value')

      return false if Ember.isEmpty value

      # FIXME: move into helper
      /^(?=.*[1-9])\d{0,5}(\.\d{1,2})?$/.test value
    ).property('controller.value', 'controller.isSubmitted')

    isInvalid: ( ->
      (not @get('isValid')) && @get('controller.isSubmitted')
    ).property('controller.value', 'controller.isSubmitted')

  referenceName: ( ->
    # FIXME : can we use toString on the models?
    reference = @get('controller.reference')

    return unless reference

    return reference.get('subject') if reference.constructor is Radium.Email
    return reference.get('topic') if reference.constructor is Radium.Todo
    return reference.get('name') if reference.constructor is Radium.Contact

    ""
  ).property('controller.reference')
