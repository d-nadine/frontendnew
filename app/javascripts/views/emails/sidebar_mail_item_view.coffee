Radium.SidebarMailItemView = Em.View.extend Radium.ContentIdentificationMixin,
  tagName: 'li'
  templateName: 'emails/sidebar_mail_item'
  classNameBindings: ['controller.isSelected', 'controller.isChecked', 'controller.isRead']

  checkMailItem: Em.Checkbox.extend
    checkedBinding: 'controller.isChecked'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @toggleProperty 'checked'
