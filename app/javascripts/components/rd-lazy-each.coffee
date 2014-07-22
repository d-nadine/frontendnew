##
# A lazy each loop to iterate over potentially infinite lists
#
# {{#rd-lazy-each content=myBigList endInSight="loadMoreData"}}
#   this is lazy item {{name}}
# {{/rd-lazy-each}}
Radium.RdLazyEachComponent = Ember.Component.extend
  classNames: ['rd-lazy-each']

  content: Ember.computed -> []
  height: 600
  rowHeight: 60
  width: null
  elementWidth: null
  #When the end of the list is within this many elements, fire off "endInSight"
  horizon: 10
  horizonThresholdCrossedBinding: "withinHorizon"
  lastVisibleIndex: (->
    return @get('listView._lastEndingIndex') || @get('height') / @get('rowHeight')
  ).property().volatile()
  contentLengthDidChange: Ember.observer 'content.length', (->
    if @get('withinHorizon')
      @sendAction "endInSight"
  )
  layout: Ember.Handlebars.compile "{{view listView}}"

  listView: Ember.computed 'template', ->
    get = Ember.get
    parentView = this._parentView
    console.log 'parentView', parentView
    console.log 'parentView.cloneKeywords', parentView.cloneKeywords
    listView = Ember.ListView.createWithMixins
      lazyEach: this
      content: Ember.computed.oneWay 'lazyEach.content'
      height: Ember.computed.oneWay 'lazyEach.height'
      rowHeight: Ember.computed.oneWay 'lazyEach.rowHeight'
      width: Ember.computed.oneWay 'lazyEach.width'
      elementWidth: Ember.computed.oneWay 'lazylist.elementWidth'
      scrollTop: 0
      itemViewClass: Ember.ListItemView.extend
        template: @get 'template'
        context: get(parentView, 'context'),
        controller: get(parentView, 'controller'),
        templateData: { keywords: parentView.cloneKeywords() }
        click: ->
          console.log 'clicked!'
    listView.on('scrollYChanged', this, "scrollYChanged")
    return listView

  scrollYChanged: ->
    @notifyPropertyChange 'lastVisibleIndex'

  withinHorizon: Ember.computed 'lastVisibleIndex', 'content.length', ->
    return false unless @get("lastVisibleIndex")?
    return @get("content.length") - @get("lastVisibleIndex") < @get("horizon")


  notifyEndInSight: Ember.observer('horizonThresholdCrossed', ->
    if @get("horizonThresholdCrossed")
      @sendAction "endInSight"
  )

  scrollTo: (y)->
    @get('listView').scrollTo y
