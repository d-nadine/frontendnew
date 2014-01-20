Radium.FlashNewViewMixin = Ember.Mixin.create
  classNameBindings: ['animateNewItem:isNewItem']
  flash: (->
    # isNew as a class name binding isn't reliable at the moment,
    # so this is a temp fix so new items flash on insert

    if @get('content.isNew')
      @$().addClass('is-new-item')
      Ember.run.later(this, ->
        @$()?.removeClass('is-new-item')
      , 100)
  ).on('didInsertElement')
