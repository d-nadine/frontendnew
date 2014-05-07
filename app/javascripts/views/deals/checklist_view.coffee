Radium.ChecklistItemMixin = Ember.Mixin.create(Ember.TargetActionSupport,
  classNameBindings: ['isInvalid']
  isValid: Ember.computed.not 'isInvalid'
  isSubmitted: Ember.computed.oneWay 'targetObject.isSubmitted'
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
    isInvalid: ( ->
      return false unless @get('isSubmitted')
      not @get('targetObject.newItemDescription.length')
    ).property('targetObject.newItemDescription', 'isSubmitted')

  newItemWeight: Ember.TextField.extend Radium.ChecklistItemMixin,
    attributeBindings: ['min', 'max']
    valueBinding: 'targetObject.newItemWeight'
    placeholder: 0
    isInvalid: ( ->
      return false unless @get('isSubmitted')
      not @get('targetObject.newItemWeight.length')
    ).property('targetObject.newItemWeight', 'isSubmitted')
