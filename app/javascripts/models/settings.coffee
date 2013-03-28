Radium.Settings = DS.Model.extend
  negotiatingStatuses: DS.attr('array')
  # FIXME: Should there be a user's setting object
  # that is separate from the global settings?
  signature: DS.attr('string')
