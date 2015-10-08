Radium.SearchSectionComponent = Ember.Component.extend
  classNames: "main-search-results-section"
  isOpen: false
  toggleSection: (event) ->
    @toggleProperty 'isOpen'