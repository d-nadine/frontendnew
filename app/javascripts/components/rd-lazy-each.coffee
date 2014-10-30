##
# A lazy each loop to iterate over potentially infinite lists
#
# {{#rd-lazy-each content=myBigList endInSight="loadMoreData"}}
#   this is lazy item {{name}}
# {{/rd-lazy-each}}
Radium.RdLazyEachComponent = Ember.Component.extend
  classNames: ['rd-lazy-each']

  content: Ember.computed -> []
  autoHeight: true
  height: 800
  rowHeight: 60
  width: null
  elementWidth: null
  #When the end of the list is within this many elements, fire off "endInSight"
  horizon: 10
  horizonThresholdCrossedBinding: "withinHorizon"

  lastVisibleIndex: (->
    return @get('listView._lastEndingIndex') || @get('height') / @get('rowHeight')
  ).property().volatile()

  contentLengthDidChange: Ember.observer 'content.length', ->
    if @get('withinHorizon')
      @sendAction "endInSight"

  layout: Ember.Handlebars.compile "{{view listView}}"

  listView: Ember.computed 'template', ->
    get = Ember.get
    parentView = this._parentView
    # HACK: need to add this for certain views
    container = parentView.get('controller.container')

    listView = Ember.ListView.createWithMixins
      lazyEach: this
      content: Ember.computed.readOnly 'lazyEach.content'
      height: Ember.computed.oneWay 'lazyEach.height'
      autoHeight: Ember.computed.readOnly 'lazyEach.autoHeight'
      rowHeight: Ember.computed.readOnly 'lazyEach.rowHeight'
      width: Ember.computed.readOnly 'lazyEach.width'
      elementWidth: Ember.computed.readOnly 'lazylist.elementWidth'
      scrollTop: 0
      container: container
      itemViewClass: Ember.ListItemView.extend
        template: @get 'template'
        context: get(parentView, 'context'),
        controller: get(parentView, 'controller'),
        container: container
        templateData: { keywords: parentView.cloneKeywords() }
      setup: (->
        return unless @get('autoHeight')

        $(window).on 'resize.lazyEach', @resizeHeight.bind(this)

        @resizeHeight()
      ).on('didInsertElement')

      teardown: (->
        $(window).off 'resize.lazyEach'
      ).on 'willDestroyElement'

      resizeHeight: ->
        return unless @get('autoHeight')
        height = (window.innerHeight - @$().offset().top) + 20
        @set('lazyEach.height', height)

    listView.on('scrollYChanged', this, "scrollYChanged")

    return listView

  scrollYChanged: ->
    @notifyPropertyChange 'lastVisibleIndex'

  withinHorizon: Ember.computed 'lastVisibleIndex', 'content.length', ->
    return false unless @get("lastVisibleIndex")?
    return @get("content.length") - @get("lastVisibleIndex") < @get("horizon")

  notifyEndInSight: Ember.observer 'horizonThresholdCrossed', ->
    if @get("horizonThresholdCrossed")
      @sendAction "endInSight"

  scrollTo: (y)->
    @get('listView').scrollTo y
