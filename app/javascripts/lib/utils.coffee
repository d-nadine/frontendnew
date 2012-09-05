Radium.Utils = Em.Object.create
  scrollWhenLoaded: (collection, className, callback) ->
    scrollTo = ->
      Ember.run.next ->
        element = $(".#{className}")

        element.ScrollTo
          duration: 500
          offsetTop: 100
          callback: ->
            callback() if callback?

    observer = ->
      if !collection.get('isLoading')
        collection.removeObserver('isLoading', observer)
        scrollTo()

    if collection.get('isLoading')
      collection.addObserver 'isLoading', observer
    else
      scrollTo()


