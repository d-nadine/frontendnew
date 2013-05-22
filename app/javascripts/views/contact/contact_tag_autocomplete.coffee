require 'lib/radium/tag_autocomplete'

Radium.ContactTagAutocomplete = Radium.TagAutoComplete.extend
  onlyOnNew: true

  init: ->
    @_super.apply this, arguments
    Ember.addBeforeObserver this, 'controller.company.tags', null, 'sourceWillChange'

  sourceWillChange: ->
    return if @get('onlyOnNew') && !@get('controller.isNew')
    return unless @get('controller.company.tags.length')

    @get('source').removeObjects @get('source').filter (tag) =>
      @get('source').mapProperty('name').contains (tag.get('name'))

  companyDidChange: ( ->
    return if @get('onlyOnNew') &&  !@get('controller.isNew')

    return unless @get('controller.company.tags.length')

    companyTags = @get('controller.company.tags').toArray().reject (tag) =>
      @get('source').mapProperty('name').contains (tag.get('name'))

    @get('source').addObjects(companyTags)
  ).observes('controller.company')
