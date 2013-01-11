Radium.RunWhenLoadedMixin = Ember.Mixin.create
  runWhenLoaded: (object, callback) ->
    if object.get('isLoaded')
      Ember.run.next ->
        callback.apply object
    else
      observer = ->
        callback.apply object
        object.removeObserver 'isLoaded', observer

      object.addObserver 'isLoaded', observer
