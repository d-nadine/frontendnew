Radium.MessagesSidebarItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  tagName: 'li'
  layoutName: 'messages/sidebar_item'
  classNameBindings: [
    'itemClass'
    'controller.isSelected'
    'controller.isChecked'
    'controller.hasTasks'
    'controller.isTracked:is-tracked:is-untracked'
    'controller.isRead:is-read:is-unread'
  ]

  itemClass: (->
    "#{@templateMap[@get('content.content.constructor')]}-item"
  ).property()

  templateMap:
    'Radium.Email': 'email'
    'Radium.Discussion': 'discussion'

  templateName: ( ->
    part = @templateMap[@get('content.content.constructor')]
    "messages/#{part}_sidebar_item"
  ).property('content')

  checker: Radium.Checkbox.extend
    classNames: ['checker-block']
    checkedBinding: 'controller.isChecked'

    click: (event) ->
      event.stopPropagation()
      @get('controller').send('check', @get('controller.content'))
