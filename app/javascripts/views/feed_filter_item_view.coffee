Radium.FeedFilterItemView = Ember.View.extend
  tagName: 'li'
  templateName: 'filter'
  classNames: ['main-filter-item']
  classNameBindings: ['isSelected:active', 'type']
  controllerBinding: 'Radium.router.feedController'
  typeBinding: 'content.type'

  isSelected: (->
    @get('controller.typeFilter') == @get('content.type') ||
      ( !@get('controller.typeFilter') && @get('content.type') == 'all' )
  ).property('controller.typeFilter')
