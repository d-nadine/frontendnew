# This file require's your application and initializes it.
# This code is called in development and integration test mode. It is
# not called during unit tests. This is to prevent your app from booting
# and paying costly initialization costs when you should only be testing
# small parts in isolation.
#
# Here's an example:
#
#   require('app')
#   Radium.boot()
#
# Your boot code begins here...
window.intercomSettings =
  company:
    # TODO: Insert the current company id here
    id: "123"
    # TODO: Insert the current company name here
    name: "Radium"
    # TODO: Insert the current company created at UNIX timestamp here
    created_at: 1234567890

  app_id: "d5bd1654e902b81ba0f4161ea5b45bb597bfefdf"
require 'app'

#Radium.initialize()
