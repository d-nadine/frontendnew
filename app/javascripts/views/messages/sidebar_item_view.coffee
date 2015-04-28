Radium.MessagesSidebarItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  tagName: 'li'
  classNames: ['messages-list-item', 'message-list-readable-item']
  layoutName: 'messages/sidebar_item'
  classNameBindings: [
    'itemClass'
    'controller.isSelected'
    'controller.isChecked'
    'controller.hasTasks'
    'itemType'
  ]

  setup: Ember.on 'didInsertElement', ->
    @$('a.archive').tooltip()

  teardown: Ember.computed 'willDestroyElement', ->
    return unless @$

    @$('a.archive')?.data('tooltip')?.destroy()

  itemClass: Ember.computed ->
    "#{@get('itemType')}-item"

  templateName: Ember.computed 'content', ->
    "messages/#{@get('itemType')}_sidebar_item"

  itemType: Ember.computed 'content.content', ->
    return unless content = @get('content.content')

    content.humanize().singularize()

  checker: Radium.Checkbox.extend
    classNames: ['checker-block']
    checkedBinding: 'controller.isChecked'

    click: (event) ->
      event.stopPropagation()
      @get('controller').send('check', @get('controller.content'))
