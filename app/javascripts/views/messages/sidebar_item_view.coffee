Radium.MessagesSidebarItemView = Em.View.extend Radium.ContentIdentificationMixin,
  tagName: 'li'
  layoutName: 'messages/sidebar_item'
  classNameBindings: ['controller.isSelected', 'controller.isChecked', 'controller.isRead']

  templateMap:
    'Radium.Email': 'email'
    'Radium.Discussion': 'discussion'

  templateName: ( ->
    part = @templateMap[@get('content.content.constructor')]
    "messages/#{part}_sidebar_item"
  ).property('content')

  checkMailItem: Em.Checkbox.extend
    checkedBinding: 'controller.isChecked'
    click: (e) ->
      e.stopPropagation()
