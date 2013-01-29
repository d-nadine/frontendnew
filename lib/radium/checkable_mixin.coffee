require 'radium/filtered_array'

Radium.CheckableMixin = Ember.Mixin.create
  checkedContent: (->
    Radium.FilteredArray.create
      context: this
      contentBinding: 'context.content'
      filterProperties: ['isChecked']
  ).property('content')

  hasCheckedContent: (->
    !Ember.isEmpty(@get('checkedContent'))
  ).property('checkedContent.length')

  toggleChecked: ->
    allChecked = @get('checkedContent.length') == @get('length')

    @get('content').forEach (email) ->
      email.set 'isChecked', !allChecked
