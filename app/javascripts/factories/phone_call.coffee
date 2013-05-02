Factory.define 'phone_call', traits: 'timestamps',
  to: -> Factory.build 'user'
  from: -> Factory.build 'contact'
  length: -> Math.floor(Math.random() * 60 * 60)

Factory.define 'voice_mail', traits: 'timestamps',
  to: -> Factory.build 'user'
  from: -> Factory.build 'contact'
  length: -> Math.floor(Math.random() * 60 * 60)

