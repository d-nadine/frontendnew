Radium.FeedFilterItemView = Ember.View.extend
  tagName: 'li'
  templateName: 'filter'
  classNames: ['main-filter-item']
  classNameBindings: ['isSelected:active']

  isSelected: (->
    @get('controller.typeFilter') == @get('content.type')
  ).property('controller.typeFilter')
