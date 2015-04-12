Radium.ChecklistItemMixin = Ember.Mixin.create(Ember.TargetActionSupport,
  classNameBindings: ['isInvalid']
  isValid: Ember.computed.not 'isInvalid'
  newItemSubmitted: Ember.computed.oneWay 'targetObject.newItemSubmitted'
  insertNewline: (e) ->
    @get('targetObject').send 'createNewItem'
)

Radium.ChecklistView = Ember.View.extend
  templateName: 'deals/checklist'

  didInsertElement: ->
    @_super.apply this, arguments
    @get('controller').on('newItemCreated', this, 'setFocus')
    Ember.run.scheduleOnce 'afterRender', this, 'setFocus'

  setFocus: ->
    return unless @get('itemDescription')

    @get('itemDescription').$().focus()

  newItemDescription: Ember.TextField.extend Radium.ChecklistItemMixin,
    valueBinding: 'targetObject.newItemDescription'
    placeholder: "Add additional item"
    isInvalid: Ember.computed 'targetObject.newItemDescription', 'newItemSubmitted', ->
      return false unless @get('newItemSubmitted')
      not @get('targetObject.newItemDescription.length')

  newItemWeight: Ember.TextField.extend Radium.ChecklistItemMixin,
    attributeBindings: ['min', 'max']
    valueBinding: 'targetObject.newItemWeight'
    placeholder: 0
    isInvalid: Ember.computed 'targetObject.newItemWeight', 'newItemSubmitted', ->
      return false unless @get('newItemSubmitted')
      newItemWeight = @get('targetObject.newItemWeight') || ''
      !newItemWeight.length || isNaN(newItemWeight) || parseInt(newItemWeight) <= 0
