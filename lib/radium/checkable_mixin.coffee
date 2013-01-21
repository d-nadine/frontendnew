Radium.CheckableMixin = Ember.Mixin.create
  checkedContent: (->
    Em.ArrayProxy.create Ember.FilterableMixin,
      context: this
      contentBinding: 'context.content'
      filterProperties: ['isChecked']
  ).property('content')

  checkedContentDidChange: (->
    checkedLength = @get 'checkedContent.length'

    if checkedLength > 0
      @connectOutlet "bulkEmailActions"
    else
      @connectOutlet "emailPanel"
  ).observes('content', 'checkedContent.length')

  toggleChecked: ->
    allChecked = @get('checkedContent.length') == @get('length')

    @get('content').forEach (email) ->
      email.set 'isChecked', !allChecked

