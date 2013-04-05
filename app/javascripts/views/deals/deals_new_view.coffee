require 'lib/radium/progress_bar'

Radium.DealsNewView= Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  showChecklistItems: false

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
    classNameBindings: ['isInvalid']
    rows: 3
    valueBinding: 'controller.description'
    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('controller.isSubmitted')
    ).property('value', 'controller.isSubmitted')

  source: Radium.Combobox.extend
    classNameBindings: ['isInvalid']
    sourceBinding: 'controller.controllers.dealSources.dealSources'
    valueBinding: 'controller.source'
    isInvalid: (->
      Ember.isEmpty(@get('controller.source')) && @get('controller.isSubmitted')
    ).property('value', 'controller.isSubmitted')

  dealStatuses: Ember.Select.extend
    contentBinding: 'controller.statuses'
    valueBinding: 'controller.status'

  referenceName: ( ->
    # FIXME : can we use toString on the models?
    reference = @get('controller.reference')

    return unless reference

    return reference.get('subject') if reference.constructor is Radium.Email
    return reference.get('topic') if reference.constructor is Radium.Todo
    return reference.get('name') if reference.constructor is Radium.Contact

    ""
  ).property('controller.reference')
