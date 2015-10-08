Ember.Handlebars.registerBoundHelper 'previewData', (value, options) ->
  return unless value

  row =  @get('_parent.firstDataRow')
  headerData = @get('_parent.headerData')

  index = headerData.indexOf value

  previewData = row[index].get('name')

  new Handlebars.SafeString("<span class='help-inline preview-inline'>#{previewData}</span>")
