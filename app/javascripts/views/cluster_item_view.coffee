Radium.ClusterItemView = Ember.View.extend
  contentBinding: 'parentView.content'
  templateName: 'cluster_item'
  classNames: 'alert cluster-item'.w()
  classNameBindings: ['expanded']
  expandedBinding: 'parentView.expanded'
  click: ->
    @toggleProperty('expanded')

  contextString: ( (source) ->
    type = Radium.Core.typeToString @get('content.type')
    type.pluralize().humanize()
  ).property()
