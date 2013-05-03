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
      if source.get('value')
        Ember.run =>
          @addNew()

    @addNew() unless @get('childViews.length')

  willDestroyElement: ->
    @_super.apply this, arguments

    unsaved = @get('source').filter (item) ->
                not item.get('value')

    unsaved.forEach (item) ->
      item.deleteRecord()

    @get('source').removeObjects unsaved

    if !@get('source').findProperty('isPrimary') && @get('source.length')
      @set('source.firstObject.isPrimary', true)

  # sourceDidChange: ( ->
  #   return unless @get('canReset')
  #   return unless @get('source')

  #   index = 0

  #   @get('labels').forEach (label) =>
  #     existing = @get('source').find (item) ->
  #       item.get('name') == label

  #     unless existing
  #       record = @get('type').createRecord({name: label, value: ''})
  #       @get('source').insertAt(index, record)

  #     index++

  #   @clear()

  #   @set('currentIndex', -1)

  #   @get('source').forEach (source) =>
  #     if source.get('value')
  #       Ember.run =>
  #         @addNew()

  #   unless @get('childViews.length')
  #     @addNew()
  #   else
  #     isPrimary = @get('source').findProperty 'isPrimary'

  #     unless isPrimary
  #       @set('source.firstObject.isPrimary', true)

  # ).observes('source.[]')

  removeSelection: (view) ->
    if view.get('current').deleteRecord
      view.get('current').deleteRecord()
      @get('controller.store').commit()

    @set('currentIndex', @get('currentIndex') - 1)

    @get('source').removeObject(view.get('current'))

    @removeObject view

  addNew: ->
    @set('currentIndex', @get('currentIndex') + 1)

    if @get('currentIndex') >= @get('labels.length') || @get('currentIndex') < 0
      @set('currentIndex', 0)

    label = @get('labels')[@get('currentIndex')]

    record = if @get('source').createRecord
               @get('source').createRecord({name: label, value: ''})
            else
               isPrimary = @get('source.length') == 0
               Ember.Object.create({name: label, value: '', isPrimary: isPrimary})

    @get('source').pushObject(record)

    @pushObject(@get('viewType').create
      classNameBindings: [':control-group']
      leader: @get('leader')
      type: @get('inputType')
      index: @get('source.length') - 1
      current: record
    )
