Radium.MultipleItemController = Radium.ObjectController.extend
  parent: Ember.computed.alias 'target.target'
  labels: Ember.computed.alias 'parent.labels'
  leader: Ember.computed.alias 'parent.leader'
  typeLabel: ( ->
    "#{@get('name')} #{@get('leader')}"
  ).property('leader', 'name')

  toggleOpen: ->
    @toggleProperty 'open'

  selectValue: (value) ->
    @set('model.name', value.toString())
    @toggleOpen()

  name: ( ->
    @get('content.name').capitalize()
  ).property('content.name')

  showAddNew: ( ->
    return if @get('parent.length') <= 1 && @get('value.length') < 2

    (@isLastElement() && (@get('value.length') >= 2))
  ).property('parent.[]', 'value')

  isLastElement: ->
    lastIndex = @get('parent.length') - 1

    @get('model') == @get('parent').objectAt(lastIndex)

  showAddNewAddress: ( ->
    return unless @isLastElement()

    return true if @get('street.length') > 1
    return true if @get('city.length') > 1
    return true if @get('state.length') > 1
    return true if @get('zipcode.length') > 1
  ).property('parent.[]', 'street', 'city', 'state', 'zip')

  showDropDown: ( ->
    @get('parent.length') > 1
  ).property('parent.[]')

  showDelete: ( ->
    @get('parent.length') > 1
  ).property('parent.[]')
