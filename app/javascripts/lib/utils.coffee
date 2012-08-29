Radium.Utils = Em.Object.create
  scrollWhenLoaded: (collection, className) ->
    scrollTo = ->
      $(".#{className}").ScrollTo()

    observer = ->
      if collection.get('isLoaded')
        collection.removeObserver('isLoaded', observer)
        Ember.run.next this, scrollTo

    if collection.get('isLoaded')
      scrollTo()
    else
      collection.addObserver 'isLoaded', observer


