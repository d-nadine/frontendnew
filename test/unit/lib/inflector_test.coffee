test 'humanize removes underscores and converts to lower case', ->
  hm = Radium.Inflector.humanize
  equal hm('THIS_is_SPARTA!'), 'this is sparta!', ''
  equal hm('1 feed_section'), '1 feed section', ''

test 'pluralize converts word to plural', ->
  p = Radium.Inflector.pluralize
  equal p('thing'), 'things', ''

test 'singularize converts word to singular', ->
  s = Radium.Inflector.singularize
  equal s('things'), 'thing', ''

test 'capitalize changes first letter to uppercase', ->
  equal Radium.Inflector.capitalize('thing'), 'Thing', ''
