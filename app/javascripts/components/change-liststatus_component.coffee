Radium.ChangeListstatusComponent = Ember.Component.extend
  currentListStatus: Ember.computed 'deal', ->
    deal = @get('deal')

    return unless deal.get('isLoaded')
