Radium.MultipleItemController = Radium.ObjectController.extend
  actions:
    setIsPrimary: ->
      @get('parent').setEach('isPrimary', false)
      @set('isPrimary', true)
      @send 'stopEditing' if @get('record')

    removeSelection: (item) ->
      parent = @get('parent')

      if record = item.get('record')
        retlationShip = if item.record.constructor is Radium.EmailAddress
                          'emailAddresses'
                        else if item.record.constructor is Radium.PhoneNumber
                          'phoneNumbers'
                        else
                          'addresses'

        @send 'removeMultiple', retlationShip, item.get('record')

      @get('parent').removeObject item

      unless parent.get('length')
        @send('stopEditing')

      isPrimary = @get('parent').find (item) -> item.get('isPrimary')

      if isPrimary
        @send('stopEditing')
        return

      nextIsPrimary = parent.filter((item) -> item.record)?.get('firstObject')

      nextIsPrimary ||= parent.get('firstObject')

      nextIsPrimary.set 'isPrimary', true

      @send('stopEditing')

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
