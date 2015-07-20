require "mixins/persist_tags_mixin"

Radium.CompanyController = Radium.ObjectController.extend Radium.AttachedFilesMixin,

  needs: ['users', 'accountSettings',  'tags', 'companies', 'countries', 'contactStatuses', 'pipelineOpendeals']
  contactStatuses: Ember.computed.alias 'controllers.contactStatuses'
