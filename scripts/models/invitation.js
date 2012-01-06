define('models/invitation', function(require) {
  
  require('ember');
  require('data');
  
  Radium.Invitation = Radium.Message.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    // FIXME: Add validation, state can only have pending, cancelled, or rescheduled
    state: DS.attr('string'),
    hash_key: DS.attr('string'),
    // FIXME: DS.hasOne
    meeting: 1,
    // FIXME: DS.hasOne
    user: 28
  });
});