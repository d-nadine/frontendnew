Radium.MultipleEmailAddressController = Radium.ArrayController.extend
  labels: ['Work','Home']
  addNew: ->
    currentIndex = @get('length')
    label = @get('labels')[currentIndex % @get('labels.length')]
    @get('content').pushObject Ember.Object.create isPrimary: false, name: label, value: ''

  removeSelection: (item) ->
    if item.hasOwnProperty 'record'
      record = item.record
      record.deleteRecord()
      @get('store').commit()

    @removeObject item
