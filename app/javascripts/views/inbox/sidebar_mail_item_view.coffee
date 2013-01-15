Radium.SidebarMailItemView = Em.View.extend Radium.ContentIdentificationMixin,
  tagName: 'li'
  templateName: 'radium/inbox/sidebar_mail_item'
  classNameBindings: ['isActive:selected', 'isSelected:checked', 'read']
  isSelectedBinding: 'content.isSelected'

  readBinding: 'content.read'

  isActive: ( ->
    @get('content') == @get('controller.active')
  ).property('content', 'controller.active')

  checkMailItem: Em.Checkbox.extend
    checkedBinding: 'parentView.content.isSelected'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @set('parentView.content.isSelected', not @get('parentView.content.isSelected'))

  click: (e) ->
    e.stopPropagation()
    @set('controller.active',  @get('content'))
