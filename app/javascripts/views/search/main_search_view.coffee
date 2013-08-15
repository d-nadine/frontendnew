Radium.SearchMainView = Ember.View.extend
  classNames: 'main-search'
  templateName: 'search/main'

  searchInput: Ember.TextField.extend
    focusIn: ->
      @set('controller.isOpen', true)

    focusOut: ->
      @set('controller.isOpen', false)