Factory.define 'user', traits: ['timestamps', 'avatar'],
  public: true
  name: Factory.sequence (i) -> "User #{i}"
  email: Factory.sequence (i) -> "user#{i}@example.com"

