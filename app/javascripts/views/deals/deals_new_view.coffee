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

  dealValue: Ember.TextField.extend
    classNameBindings: ['isValid','isInvalid',':field']
    valueBinding: 'controller.value'

    isValid: ( ->
      value = @get('value')

      return false if Ember.isEmpty value
      return false if parseInt(value) == 0

      # FIXME: move into helper
      /^(?=.*[1-9])\d{0,5}(\.\d{1,2})?$/.test value
    ).property('value', 'isSubmitted')

    isInvalid: ( ->
      (not @get('isValid')) && @get('controller.isSubmitted')
    ).property('value', 'controller.isSubmitted')

  referenceName: ( ->
    # FIXME : can we use toString on the models?
    reference = @get('controller.reference')

    return unless reference

    return reference.get('subject') if reference.constructor is Radium.Email
    return reference.get('topic') if reference.constructor is Radium.Todo
    return reference.get('name') if reference.constructor is Radium.Contact

    ""
  ).property('controller.reference')
