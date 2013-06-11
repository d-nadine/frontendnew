Radium.MultipleItemController = Radium.ObjectController.extend
  leader: 'Email'
  parent: Ember.computed.alias 'target.target'
  labels: Ember.computed.alias 'parent.labels'
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

    lastIndex = @get('parent.length') - 1

    return ((@get('model') == @get('parent').objectAt(lastIndex)) && (@get('value.length') >= 2))
  ).property('parent.[]', 'value')

  showDropDown: ( ->
    @get('parent.length') > 1
  ).property('parent.[]')

  showDelete: ( ->
    @get('parent.length') > 1
  ).property('parent.[]')
