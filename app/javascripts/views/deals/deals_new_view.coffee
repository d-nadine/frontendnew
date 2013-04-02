require 'lib/radium/progress_bar'

Radium.DealsNewView= Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  showChecklistItems: false

  isFinished: Ember.Checkbox.extend
    click: (evt) ->
      evt.stopPropagation()
      @set('controller.selectedCheckboxItem', @get('selected'))

  toggleChecklist: (evt) ->
    @$('.checklist-items-container').slideToggle('medium')
    @toggleProperty 'showChecklistItems'

  name: Ember.TextField.extend
    classNameBindings: ['isInvalid',':field']
    valueBinding: 'controller.name'
    didInsertElement: ->
      @$().focus()

    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('controller.isSubmitted')
    ).property('value', 'controller.isSubmitted')

  contactPicker: Radium.Combobox.extend
    classNames: ['field']
    sourceBinding: 'controller.contacts'
    valueBinding: 'controller.contact'

  userPicker: Radium.UserPicker.extend
    classNames: ['field']
    leader: null

  description: Radium.TextArea.extend
    valueBinding: 'controller.description'
    rows: 3

  dealStatuses: Ember.Select.extend
    contentBinding: 'controller.statuses'
    valueBinding: 'controller.status'

  progressBar: Radium.ProgressBar.extend()

  referenceName: ( ->
    # FIXME : can we use toString on the models?
    reference = @get('controller.reference')

    return unless reference

    return reference.get('subject') if reference.constructor is Radium.Email
    return reference.get('topic') if reference.constructor is Radium.Todo
    return reference.get('name') if reference.constructor is Radium.Contact

    ""
  ).property('controller.reference')

  publishedSwitch: Radium.ToggleSwitch.extend
    classNames: ['published-switch']
    checkedBinding: 'controller.isPublished'
