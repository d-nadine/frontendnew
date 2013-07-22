Radium.SearchResultItemView = Radium.View.extend
  templateName: ( ->
    type = @get('controller.model.typeName')

    "search/#{type}"
  ).property('controller.model')
