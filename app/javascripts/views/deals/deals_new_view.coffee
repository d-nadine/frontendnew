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
