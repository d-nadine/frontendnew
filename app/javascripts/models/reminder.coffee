Radium.Reminder = Radium.Core.extend
  via: DS.attr('string')
  time: DS.attr('datetime')
  reference: Radium.polymorphic('reference')
