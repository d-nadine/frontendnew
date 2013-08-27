require 'lib/radium/progress_bar'
require 'lib/radium/radio'
require 'lib/radium/text_combobox'
require 'lib/radium/autocomplete_combobox'
require 'lib/radium/contact_picker'
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

  contactPicker: Radium.ContactPicker.extend(Radium.ValueValidationMixin)

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
        <span class="error"><i class="ss-standard ss-alert"></i>Value must be greater than 0.</span>
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
    return reference.get('displayName') if reference.constructor is Radium.Contact

    ""
  ).property('controller.reference')
