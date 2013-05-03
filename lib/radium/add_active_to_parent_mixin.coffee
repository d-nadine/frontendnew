Radium.AddActiveToParentMixin = Ember.Mixin.create
  focusIn: (evt) ->
    @get('parentView').$().addClass('active')

  focusOut: (evt) ->
    @get('parentView').$().removeClass('active')
