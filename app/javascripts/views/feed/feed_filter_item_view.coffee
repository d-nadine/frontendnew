Radium.FeedFilterItemView = Ember.View.extend
  tagName: 'li'
  templateName: 'radium/filter'
  classNameBindings: ['isSelected:selected']
  attributeBindings: ['dataType:data-type']
  dataType: (->
    @get('content.type')
  ).property('content.type')

  # FIXME: why is this on the view instead of the controller?
  setFilter: (event) ->
    type = if event.context == 'all' then null else event.context
    @get('controller').set('typeFilter', type)

  isSelected: (->
    @get('controller.typeFilter') == @get('content.type') ||
      ( !@get('controller.typeFilter') && @get('content.type') == 'all' )
  ).property('controller.typeFilter')

