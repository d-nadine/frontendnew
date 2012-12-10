# module "Application Factories",
#   setup: ->
#     for k, v in Radium when k.hasOwnProperty('FIXTURES')
#       k.FIXTURES = k.FIXTURES.splice 0, v.length

#   teardown: ->
#     for k, v in Radium when k.hasOwnProperty('FIXTURES')
#       k.FIXTURES = k.FIXTURES.splice 0, v.length

# test "builds a user", ->
#   user = Factory.create 'user'
#   ok user.get('name')
