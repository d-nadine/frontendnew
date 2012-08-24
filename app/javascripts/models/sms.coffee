Radium.Sms = Radium.Message.extend
  to: DS.attr('array')
  sender: DS.belongsTo('Radium.User', key: 'sender_id')
