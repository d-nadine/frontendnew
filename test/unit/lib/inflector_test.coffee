module 'String Inflector'

test 'humanize removes underscores and converts to lower case', ->
  equal ('THIS_is_SPARTA!').humanize(), 'this is sparta!'
  equal ('1 camel_hump').humanize(), '1 camel hump'

test 'pluralize converts word to plural', ->
  equal ('thing').pluralize(), 'things'

test 'singularize converts word to singular', ->
  equal ('things').singularize(), 'thing'

test 'capitalize changes first letter to uppercase', ->
  equal ('thing').capitalize(), 'Thing'
