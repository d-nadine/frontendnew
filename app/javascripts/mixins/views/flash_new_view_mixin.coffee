Radium.FlashNewViewMixin = Ember.Mixin.create
  classNameBindings: ['animateNewItem:isNewItem']
  didInsertElement: ->
  flash: (->
    # isNew as a class name binding isn't reliable at the moment,
    # so this is a temp fix so new items flash on insert

    if @get('content.isNew') || @get('content.newTask')
      @$().addClass('is-new-item')
      Ember.run.later(this, =>
        @$()?.removeClass('is-new-item')
        @set('content.newTask', false) if @get('content')
      , 100)
  ).on('didInsertElement')
