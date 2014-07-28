Radium.SearchResultItemView = Radium.View.extend
  classNames: 'search-result-list-item row-fluid'
  classNameBindings: ['controller.isChecked']

  didInsertElement: ->
    @$('.contact-tooltip').tooltip()

  willDestroyElement: ->
    @$('.contact-tooltip')?.tooltip('destroy')

  templateName: Ember.computed 'controller.model', ->
    type = @get('controller.model.typeName')

    "search/#{type}"
