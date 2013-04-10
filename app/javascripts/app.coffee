# First off, require all the custom additions and code
# we need to be available globally
require /lib\/patches/

require 'lib/ember/arrangable_mixin'
require 'lib/ember/filterable_mixin'
require 'lib/ember/datetime'
require 'lib/ember/computed'

require 'lib/string/inflector'

require 'lib/foundry'

Radium = Em.Application.create
  rootElement: '#application'

window.Radium = Radium

require /lib\/base/

require 'lib/radium/computed'

require 'lib/radium/run_when_loaded_mixin'

require 'utils'

require 'store'

require 'routes'
requireAll /routes/

require 'models'

require 'views'

require 'lib/radium/checkable_mixin'
require 'lib/radium/selectable_mixin'

require 'controllers'

require /helpers/

require 'factories'
