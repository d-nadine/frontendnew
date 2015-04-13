Radium.MultipleItemController = Radium.ObjectController.extend Radium.FormArrayBehaviour,
  actions:
    changeCountry: (country) ->
      @set 'model.country', country.key
      @send 'stopEditing'

    toggleOpen: ->
      @toggleProperty 'open'
      false

    selectValue: (value) ->
      @set('model.name', value.toString())
      @send 'toggleOpen'

    stopEditing: ->
      @get('parentController.parentController').send 'stopEditing'

  parent: Ember.computed.alias 'parentController'
  labels: Ember.computed.alias 'parent.labels'
  leader: Ember.computed.alias 'parent.leader'

  typeLabel: Ember.computed 'leader', 'name', ->
    "#{@get('name')} #{@get('leader')}"

  name: Ember.computed 'content.name', ->
    return 'Personal' unless @get('content.name.length')
    @get('content.name').capitalize()

  showAddNew: Ember.computed 'parent.[]', 'value', ->
    return if @get('parent.length') <= 1 && @get('value.length') < 2

    (@isLastElement() && (@get('value.length') >= 2))

  isLastElement: ->
    lastIndex = @get('parent.length') - 1

    @get('model') == @get('parent').objectAt(lastIndex)

  showAddNewAddress: Ember.computed 'parent.[]', 'street', 'city', 'state', 'zip', ->
    return unless @isLastElement()

    return true if @get('street.length') > 1
    return true if @get('city.length') > 1
    return true if @get('state.length') > 1
    return true if @get('zipcode.length') > 1
    return true if @get('email.length') > 1
    return true if @get('phone.length') > 1

  showDropDown: Ember.computed 'parent.[]', ->
    @get('parent.length') > 1

  showDelete: Ember.computed 'parent.[]', ->
    @get('parent.length') > 1
