Radium.DealsTotalsMixin = Ember.Mixin.create
  total: Ember.computed 'length', ->
    return 0 if @get('length') == 0

    ret = @reduce(((value, item) ->
      value + item.get('value')
    ), 0)

    ret