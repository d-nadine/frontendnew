Radium.SelectableMixin = Ember.Mixin.create
  selectedContent: null

  nextItem: Ember.computed 'selectedContent', ->
    selectedItem = @get('selectedContent')
    return unless selectedItem

    selectedIndex = @indexOf selectedItem
    @objectAt selectedIndex + 1
