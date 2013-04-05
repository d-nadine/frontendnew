Radium.ChecklistItemMixin = Ember.Mixin.create(Ember.TargetActionSupport,
  classNameBindings: ['isInvalid']
  insertNewline: (e) ->
    @get('parentView').createNewItem()
)

Radium.ChecklistView = Ember.View.extend
  templateName: 'deals/checklist'
  checklist: Ember.computed.alias 'controller.checklist'

  newItemDescription: Ember.TextField.extend Radium.ChecklistItemMixin,
    valueBinding: 'controller.newItemDescription'

  newItemWeight: Ember.TextField.extend Radium.ChecklistItemMixin,
    attributeBindings: ['min', 'max']
    valueBinding: 'controller.newItemWeight'

  showAddButton: ( ->
    description = @get('controller.newItemDescription')
    weight = @get('controller.newItemWeight')

    return unless /^\d+$/.test weight
    return unless parseInt(weight) <= 100

    (description.length > 0)
  ).property('controller.newItemDescription', 'controller.newItemWeight')

  createNewItem: ->
    description = @get('itemDescription.value')
    weight = parseInt(@get('itemWeight.value'))
    return if Ember.isEmpty(description)
    return if Ember.isEmpty(weight)

    checklist = @get('checklist')

    newItem =
            description: description
            weight: weight
            isFinished: true
            kind: 'additional'
            checklist: checklist

    newRecord = if @get('controller.isNew')
                  Ember.Object.create(newItem)
                else
                  @get('checklist.checklistItems').createRecord(newItem)

    if @get('controller.isNew')
      @get('checklist.checklistItems').addObject newRecord

    @set('itemDescription.value', '')
    @set('itemWeight.value', '0')
    @get('itemDescription').$().focus()

