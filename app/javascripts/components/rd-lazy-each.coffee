Radium.RdLazyEachComponent = Ember.Component.extend
  classNames: ['rd-lazy-each']

  content: Ember.computed -> []
  height: 600
  rowHeight: 60
  width: null
  elementWidth: null

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
    @sendAction "endInSight"

  scrollTo: (y)->
    @get('listView').scrollTo y
