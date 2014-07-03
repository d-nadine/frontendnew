Radium.RdLazyEachComponent = Ember.Component.extend
  classNames: ['rd-lazy-each']

  content: Ember.computed -> []
  height: 600
  rowHeight: 60
  width: null
  elementWidth: null

  layout: Ember.Handlebars.compile "{{view listView}}"

  listView: Ember.computed 'template', ->
    Ember.ListView.createWithMixins
      lazyList: this
      content: Ember.computed.oneWay 'lazyList.content'
      height: Ember.computed.oneWay 'lazyList.height'
      rowHeight: Ember.computed.oneWay 'lazyList.rowHeight'
      width: Ember.computed.oneWay 'lazyList.width'
      elementWidth: Ember.computed.oneWay 'lazylist.elementWidth'

      itemViewClass: Ember.ListItemView.extend
        template: @get 'template'
