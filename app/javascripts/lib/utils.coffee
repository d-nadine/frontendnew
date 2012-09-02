Radium.Utils = Em.Object.create
  scrollWhenLoaded: (collection, className) ->
    scrollTo = ->
      $(".#{className}").ScrollTo()

    observer = ->
      if collection.get('isLoading')
        collection.removeObserver('isLoading', observer)
        Ember.run.next this, scrollTo

    if collection.get('isLoading')
      scrollTo()
    else
      collection.addObserver 'isLoading', observer


