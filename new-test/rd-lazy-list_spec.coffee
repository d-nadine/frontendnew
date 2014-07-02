describe 'loading data into a lazy list', ->
  beforeEach ->
    @list = component 'rdLazyList'
  it 'exists', ->
    expect(@list).to.exist
    
