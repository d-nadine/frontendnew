Radium.Utils = Em.Object.create
  runWhenLoaded: (object, callback) ->
    if object.get('isLoaded')
      Ember.run.next ->
        callback.apply object
    else
      observer = ->
        callback.apply object
        object.removeObserver 'isLoaded', observer

      object.addObserver 'isLoaded', observer

  scroll: (elementOrClassName, callback) ->
    Ember.run.next ->
      element = null
      if elementOrClassName instanceof jQuery
        element = elementOrClassName
      else
        element = $(".#{elementOrClassName}")

      element.ScrollTo
        duration: 500
        offsetTop: 100
        callback: ->
          callback() if callback?

  scrollWhenLoaded: (collection, className, callback) ->
    self = this
    observer = ->
      if !collection.get('isLoading')
        collection.removeObserver('isLoading', observer)
        self.scroll(className, callback)

    if collection.get('isLoading')
      collection.addObserver 'isLoading', observer
    else
      self.scroll(className, callback)

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
