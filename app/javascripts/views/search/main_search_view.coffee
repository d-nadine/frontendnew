Radium.SearchMainView = Ember.View.extend
  classNames: 'main-search'
  templateName: 'search/main'

  didInsertElement: ->
    $('html').on 'click.dropdown.data-api', () =>
      unless @get('controller.query')
        @set('controller.isOpen', false)

  click: (event) ->
    event.stopPropagation()

  # Advanced settings
  advancedSearchSettingsView: Ember.View.extend
    sectionIsOpen: false
    toggleAdvancedSettings: ->
      @toggleProperty 'sectionIsOpen'

  # Search Input
  searchInput: Ember.TextField.extend
    cancel: ->
      @get('controller').setProperties(
        query: null
        isOpen: false
      )

      @$().blur()

    focusIn: ->
      @set('controller.isOpen', true)