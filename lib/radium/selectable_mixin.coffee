Radium.SelectableMixin = Ember.Mixin.create
  selectedContent: null

  nextItem: (->
    selectedItem = @get('selectedContent')
    return unless selectedItem

    selectedIndex = @indexOf selectedItem
    @objectAt selectedIndex + 1
  ).property('selectedContent')
