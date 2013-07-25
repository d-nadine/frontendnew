Radium.SearchResultItemView = Radium.View.extend
  classNames: 'search-result-list-item'
  classNameBindings: ['controller.isChecked']

  didInsertElement: ->
    @$('.contact-tooltip').tooltip()

  willDestroyElement: ->
    @$('.contact-tooltip').tooltip('destroy')

  templateName: ( ->
    type = @get('controller.model.typeName')

    "search/#{type}"
  ).property('controller.model')
