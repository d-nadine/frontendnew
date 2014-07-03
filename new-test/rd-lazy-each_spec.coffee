describe 'loading data into a lazy list', ->
  beforeEach ->
    @list = component 'rdLazyEach',
      height: 400
      rowHeight: 40
      content: [
        {name: 'Barney'},
        {name: 'Fred'},
        {name: 'Betty'},
        {name: 'Wilma'}
      ]
    @list.templateForName = ->
      Ember.Handlebars.compile('<div data-item>{{name}}</div>')
  it 'exists', ->
    expect(@list).to.exist
  it 'has the expected dimensions', ->
    expect(@list.$().height()).to.equal 400
  it 'contains all the items', ->
    expect(@list.$('[data-item]').length).to.equal 4
