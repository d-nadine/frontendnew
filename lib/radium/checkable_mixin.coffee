require 'lib/radium/filtered_array'

Radium.CheckableMixin = Ember.Mixin.create
  contentPath: 'arrangedContent'
  checkedContent: (->
    Radium.FilteredArray.create
      context: this
      contentBinding: "context.#{@get('contentPath')}"
      filterProperties: ['isChecked']
  ).property('arrangedContent')

  hasCheckedContent: (->
    !Ember.isEmpty(@get('checkedContent'))
  ).property('checkedContent.length')

  toggleChecked: ->
    allChecked = @get('checkedContent.length') == @get('length')

    @get('content').forEach (item) ->
      item.set 'isChecked', !allChecked
