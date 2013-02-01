Factory.define 'user', traits: ['timestamps'],
  name: Factory.sequence (i) -> "User #{i}"
  email: Factory.sequence (i) -> "user#{i}@example.com"

