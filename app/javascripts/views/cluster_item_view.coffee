Radium.ClusterItemView = Ember.View.extend
  contentBinding: 'parentView.content'
  templateName: 'cluster_item'
  classNames: 'alert cluster-item'.w()
  classNameBindings: ['expanded']
  expandedBinding: 'parentView.expanded'
  click: ->
    @toggleProperty('expanded')

  contextString: ( (source) ->
    count = @get('content.length')
    if count > 1
      "items of type #{@get('content.type')}"
    else
      "item of type #{@get('content.type')}"
  ).property('content.length')
