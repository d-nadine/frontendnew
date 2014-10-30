Radium.CheckableMixin = Ember.Mixin.create
  allChecked: false

  # FIXME: FilterBy breaks when used like this
  # I've reported this issue https://github.com/emberjs/ember.js/issues/4620
  # we want to be using filterBy and not @each
  # checkedContent: Ember.computed.filterBy '@this', 'isChecked'

  checkedContent: Ember.computed 'arrangedContent.@each.isChecked', (item) ->
    unless arrangedContent = @get('arrangedContent')
      return Ember.A()

    arrangedContent.filter (item) -> item.get('isChecked')

  hasCheckedContent: Ember.computed 'checkedContent.length', ->
    !Ember.isEmpty(@get('checkedContent'))

  toggleChecked: ->
    allChecked = @get('checkedContent.length') == @get('length')

    @get('content').forEach (item) ->
      item.set 'isChecked', !allChecked

  allCheckedDidChange: Ember.observer 'allChecked', ->
    @toggleChecked()
