Radium.Utils = Em.Object.create
  roundTime: (time) ->
    hour = time.get("hour")
    minute = time.get("minute")
    newTime = undefined
    if minute is 0
      newTime = time
    else if minute <= 29
      newTime = time.adjust(minute: 30)
    else
      newTime = time.adjust(
        hour: hour + 1
        minute: 0
      )
    newTime

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


