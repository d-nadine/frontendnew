Radium.CheckableMixin = Ember.Mixin.create
  allChecked: false

  checkedContent: Ember.computed.filterBy '@this', 'isChecked'

  # checkedContent: Ember.computed 'arrangedContent.@each.isChecked', (item) ->
  #   @get('arrangedContent').filter (item) -> item.get('isChecked')

  hasCheckedContent: (->
    !Ember.isEmpty(@get('checkedContent'))
  ).property('checkedContent.length')

  toggleChecked: ->
    allChecked = @get('checkedContent.length') == @get('length')

    @get('content').forEach (item) ->
      item.set 'isChecked', !allChecked

  allCheckedDidChange: (  ->
    @toggleChecked()
  ).observes('allChecked')
