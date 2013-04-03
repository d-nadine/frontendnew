Radium.ChecklistItemMixin = Ember.Mixin.create(Ember.TargetActionSupport,
  classNameBindings: ['isInvalid']
  insertNewline: (e) ->
    @get('parentView').createNewItem()
)

Radium.ChecklistView = Ember.View.extend
  templateName: 'deals/checklist'
  checklist: Ember.computed.alias 'controller.checklist'

  newItemDescription: Ember.TextField.extend(Radium.ChecklistItemMixin)

  newItemWeight: Ember.TextField.extend(Radium.ChecklistItemMixin)

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

    newRecord = if @get('controller.isNew')
                  Ember.Object.create(newItem)
                else
                  Radium.ChecklistItem.createRecord(newItem)

    @get('checklist.checklistItems').addObject newRecord
    @set('itemDescription.value', '')
    @set('itemWeight.value', '0')
    @get('itemDescription').$().focus()

