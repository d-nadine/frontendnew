Radium.FilteredItemsInfoView = Em.View.extend
  templateName: 'radium/filtered_items_info'
  classNames: ['filtered-items-info']

  contentBinding: 'parentView.content'
  countBinding: 'parentView.filteredViewsCount'
