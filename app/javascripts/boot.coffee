# This file require's your application and initializes it.
# This code is called in development and integration test mode. It is
# not called during unit tests. This is to prevent your app from booting
# and paying costly initialization costs when you should only be testing
# small parts in isolation.
#
# Here's an example:
#
#   require('radium/app')
#   Radium.boot()
#
# Your boot code begins here...

require 'radium/app'

FixtureSet.load()
# TODO: initially fixtures were a singleton object, but that doesn't play
#       nice with unit tests, so I changed it to a class FixtureSet,
#       this should be probably reviewed and refactored
window.F = F = window.Fixtures = Fixtures = FixtureSet.create()

Fixtures.loadAll()

Radium.initialize()
