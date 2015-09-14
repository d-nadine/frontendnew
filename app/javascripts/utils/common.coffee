Radium.Common = do ->
  wait = (condition, func, counter) ->
    if !counter
      counter = 0

    if condition || counter > 10
      func()
    else
      setTimeout wait.bind(null, condition, func, (counter + 1)), 30

  wait: wait
