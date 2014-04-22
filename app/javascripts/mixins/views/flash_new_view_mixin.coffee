Radium.FlashNewViewMixin = Ember.Mixin.create
  classNameBindings: ['animateNewItem:isNewItem']
  didInsertElement: ->
  flash: (->
    @_super.apply this, arguments
    return if ! @get('content.isNew') || !@get('content.newTask')

    @$().addClass('is-new-item')
    Ember.run.later(this, =>
      @$()?.removeClass('is-new-item')
      @set('content.newTask', false) if @get('content')
    , 100)
  ).on('didInsertElement')
