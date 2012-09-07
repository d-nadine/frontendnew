Radium.FilteredItemsInfoView = Em.View.extend
  templateName: 'filtered_items_info'
  classNames: ['filtered-items-info']

  contentBinding: 'parentView.content'
  countBinding: 'parentView.filteredViewsCount'
