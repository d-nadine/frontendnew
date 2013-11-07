Radium.ChecklistItemMixin = Ember.Mixin.create(Ember.TargetActionSupport,
  classNameBindings: ['isInvalid']
  insertNewline: (e) ->
    @get('parentView').createNewItem()
)

Radium.ChecklistView = Ember.View.extend
  actions:
    createNewItem: ->
      @get('controller').send 'createNewItem'
      @get('itemDescription').$().focus()

  templateName: 'deals/checklist'

  newItemDescription: Ember.TextField.extend Radium.ChecklistItemMixin,
    valueBinding: 'targetObject.newItemDescription'
    placeholder: "Add additional item"

  newItemWeight: Ember.TextField.extend Radium.ChecklistItemMixin,
    attributeBindings: ['min', 'max']
    valueBinding: 'targetObject.newItemWeight'
    placeholder: 0

  showAddButton: ( ->
    description = @get('controller.newItemDescription')
    weight = @get('controller.newItemWeight')

    return unless /^\d+$/.test weight
    return unless parseInt(weight) <= 100 && parseInt(weight) > 0

    (description.length > 0)
  ).property('controller.newItemDescription', 'controller.newItemWeight')
