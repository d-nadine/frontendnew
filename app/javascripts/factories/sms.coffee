Factory.define 'sms', traits: ['timestamps', 'message'],
  # TODO: this should be polymoprhic
  sender: -> Factory.build 'user'
