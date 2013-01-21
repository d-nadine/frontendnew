Radium.SidebarMailItemView = Em.View.extend Radium.ContentIdentificationMixin,
  tagName: 'li'
  templateName: 'radium/inbox/sidebar_mail_item'
  classNameBindings: ['isSelected:selected', 'isChecked:checked', 'read']

  readBinding: 'content.read'

  isChecked: (->
    @get('content.isChecked')
  ).property('content.isChecked')

  isSelected: ( ->
    @get('content') == @get('controller.selectedContent')
  ).property('content', 'controller.selectedContent')

  checkMailItem: Em.Checkbox.extend
    contentBinding: Ember.Binding.oneWay 'parentView.content'
    checkedBinding: 'content.isChecked'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @set('content.isChecked', not @get('content.isChecked'))
