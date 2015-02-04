Radium.MessagesSidebarItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  tagName: 'li'
  classNames: ['messages-list-item', 'message-list-readable-item']
  layoutName: 'messages/sidebar_item'
  classNameBindings: [
    'itemClass'
    'controller.isSelected'
    'controller.isChecked'
    'controller.hasTasks'
  ]

  setup: Ember.on 'didInsertElement', ->
    @$('a.archive').tooltip()

  teardown: Ember.computed 'willDestroyElement', ->
    return unless @$

    @$('a.archive')?.data('tooltip')?.destroy()

  itemClass: Ember.computed ->
    "#{@templateMap[@get('content.content.constructor')]}-item"

  templateMap:
    'Radium.Email': 'email'

  templateName: Ember.computed 'content', ->
    part = @templateMap[@get('content.content.constructor')]
    "messages/#{part}_sidebar_item"

  checker: Radium.Checkbox.extend
    classNames: ['checker-block']
    checkedBinding: 'controller.isChecked'

    click: (event) ->
      event.stopPropagation()
      @get('controller').send('check', @get('controller.content'))
