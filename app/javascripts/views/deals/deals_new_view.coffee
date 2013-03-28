Radium.DealsNewView= Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  showChecklistItems: false

  isFinished: Ember.Checkbox.extend
    click: (evt) ->
      evt.stopPropagation()
      @set('controller.selectedCheckboxItem', @get('selected'))

  toggleChecklist: (evt) ->
    div = @$('.checklist-items').slideToggle('medium')
    @toggleProperty 'showChecklistItems'

  name: Ember.TextField.extend
    valueBinding: 'controller.name'
    didInsertElement: ->
      @$().focus()

  contactPicker: Radium.Combobox.extend
    sourceBinding: 'controller.contacts'
    valueBinding: 'controller.contact'

  userPicker: Radium.UserPicker.extend
    leader: null

  description: Radium.TextArea.extend
    valueBinding: 'controller.description'
    rows: 3

  referenceName: ( ->
    reference = @get('controller.reference')

    return unless reference

    return reference.get('subject') if reference.constructor is Radium.Email
    return reference.get('topic') if reference.constructor is Radium.Todo
    return reference.get('name') if reference.constructor is Radium.Contact

    ""
  ).property('controller.reference')
