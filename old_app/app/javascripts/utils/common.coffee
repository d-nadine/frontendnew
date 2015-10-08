Radium.Common = do ->
  wait = (condition, func, counter) ->
    if !counter
      counter = 0

    if condition || counter > 10
      func()
    else
      setTimeout wait.bind(null, condition, func, (counter + 1)), 30

  addOverlay = (callback) ->
    overlay = $('<div class="modal-backdrop"/>').appendTo(document.body)

    overlay.one 'click', callback

  removeOverlay = ->
    if overlay = $('.modal-backdrop')
      overlay.remove()

  wait: wait,
  addOverlay: addOverlay,
  removeOverlay: removeOverlay
