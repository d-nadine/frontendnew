Radium.MultipleEmailAddressController = Radium.ArrayController.extend
  labels: ['Work','Personal']
  addNew: ->
    currentIndex = @get('length')
    label = @get('labels')[currentIndex % @get('labels.length')]
    item = Ember.Object.create isPrimary: false, name: label, value: ''
    @get('content').pushObject  item

  removeSelection: (item) ->
    if item.hasOwnProperty 'record'
      record = item.record
      record.deleteRecord()
      @get('store').commit()

    @removeObject item
