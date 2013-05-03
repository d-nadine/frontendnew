require 'lib/radium/multiple_field'
require 'lib/radium/address_multiple_field'

Radium.MultipleFields = Ember.ContainerView.extend
  currentIndex: -1
  inputType: 'text'
  viewType: Radium.MultipleField
  canReset: false
  didInsertElement: ->
    @_super.apply this, arguments
    @get('source').forEach (source) =>
      Ember.run =>
        @addExisting(source)

    @addNew() unless @get('childViews.length')

  willDestroyElement: ->
    @_super.apply this, arguments

    unsaved = @get('source').filter (item) ->
                not item.get('value')

    unsaved.forEach (item) ->
      if item.deleteRecord
        item.deleteRecord()

    @get('source').removeObjects unsaved

    if !@get('source').findProperty('isPrimary') && @get('source.length')
      @set('source.firstObject.isPrimary', true)

  sourceDidChange: ( ->
    return unless @get('canReset')
    return if @get('isUpdating')

    @clear()

    @set('currentIndex', -1)

    if @get('controller.model.isNew')
      @addNew()
      return

    @get('source').forEach (source) =>
      Ember.run.next =>
        console.log source.get('value')
        @addExisting(source)

  ).observes('source.[]')

  removeSelection: (view) ->
    if view.get('current').deleteRecord
      view.get('current').deleteRecord()
      @get('controller.store').commit()

    @set('currentIndex', @get('currentIndex') - 1)

    @set('isUpdating', true)

    @get('source').removeObject(view.get('current'))

    @set('isUpdating', false)

    @removeObject view

    unless @get('source').findProperty 'isPrimary'
      @set('source.firstObject.isPrimary', true)

  getNewRecord: (label) ->
    if @get('source').createRecord
       @get('source').createRecord({name: label, value: ''})
    else
       isPrimary = @get('source.length') == 0
       Ember.Object.create({name: label, value: '', isPrimary: isPrimary})

  addExisting: (record) ->
    @pushObject(@get('viewType').create
      classNameBindings: [':control-group']
      leader: @get('leader')
      type: @get('inputType')
      index: @get('source.length') - 1
      current: record
    )

  addNew: ->
    @set('currentIndex', @get('currentIndex') + 1)

    if @get('currentIndex') >= @get('labels.length') || @get('currentIndex') < 0
      @set('currentIndex', 0)

    label = @get('labels')[@get('currentIndex')]

    record = @getNewRecord(label)

    @set('isUpdating', true)

    @get('source').pushObject(record)

    @set('isUpdating', false)

    @pushObject(@get('viewType').create
      classNameBindings: [':control-group']
      leader: @get('leader')
      type: @get('inputType')
      index: @get('source.length') - 1
      current: record
    )
