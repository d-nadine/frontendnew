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
  hasCrossedThreshold: false

  layout: Ember.Handlebars.compile "{{view listView}}"

  listView: Ember.computed 'template', ->
    listView = Ember.ListView.createWithMixins
      lazyEach: this
      content: Ember.computed.oneWay 'lazyEach.content'
      height: Ember.computed.oneWay 'lazyEach.height'
      rowHeight: Ember.computed.oneWay 'lazyEach.rowHeight'
      width: Ember.computed.oneWay 'lazyEach.width'
      elementWidth: Ember.computed.oneWay 'lazylist.elementWidth'

      itemViewClass: Ember.ListItemView.extend
        template: @get 'template'
    listView.on('scrollYChanged', this, "scrollYChanged")
    return listView

  scrollYChanged: ->
    @set("lastVisibleIndex", @get("listView._lastEndingIndex"))

  withinHorizon: Ember.computed 'lastVisibleIndex', 'content.length', 'hasCrossedThreshold'->
    if @get("hasCrossedThreshold")
      return false
    return false unless @get("lastVisibleIndex")?
    return @get("content.length") - @get("lastVisibleIndex") < @get("horizon")

  notifyEndInSight: Ember.observer('horizonThresholdCrossed', ->
    if @get("horizonThresholdCrossed")
      @sendAction "endInSight"

    @set("hasCrossedThreshold", @get("horizonThresholdCrossed"))
  ).on("init")


  scrollTo: (y)->
    @get('listView').scrollTo y
