Factory.define 'user', traits: ['timestamps', 'avatar'],
  name: Factory.sequence (i) -> "User #{i}"
  email: Factory.sequence (i) -> "user#{i}@example.com"

