Radium.Message = Radium.Core.extend
  message: DS.attr('string')
  sentAt: DS.attr('date', key: 'sent_at')
  type: DS.attr('string')
