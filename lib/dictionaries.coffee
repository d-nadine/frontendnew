class Dictionary
  constructor: (@set) ->

  random: ->
    @set[Math.floor(Math.random() * @set.length)]

  add: (entry) ->
    @set.push entry

window.Dictionary = Dictionary
window.Dictionaries = {}

requireAll /lib\/dictionaries/
