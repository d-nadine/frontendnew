describe 'loading data into a lazy list', ->
  beforeEach ->
    @moar = sinon.spy =>
      @list.get('content').pushObjects [
        {name: 'Bam Bam'},
        {name: 'Pebbles'},
        {name: 'Dino'},
        {name: 'Mr Slate'}
      ]
    @list = component 'rdLazyEach',
      height: 80
      rowHeight: 40
      content: [
        {name: 'Barney'},
        {name: 'Fred'},
        {name: 'Betty'},
        {name: 'Wilma'}
      ]
      endInSight: "moar"
      targetObject:
        moar: @moar
    @list.templateForName = ->
      Ember.Handlebars.compile('<div data-item>{{name}}</div>')
  it 'exists', ->
    expect(@list).to.exist
  it 'has the expected dimensions', ->
    expect(@list.$().height()).to.equal 80
  it 'contains all the items', ->
    expect(@list.$('[data-item]').length).to.equal 3

  describe 'scrolling near the end', ->
    beforeEach ->
      @list.scrollTo(140)
    it 'asks for more data', ->
      expect(@moar).to.have.been.called

    describe 'scrolling just a bit more', ->
      beforeEach ->
        @moar.reset()
        @list.scrollTo(141)
      it 'does not ask for more data', ->
        expect(@moar).not.to.have.been.called
    describe 'scrolling to the end of the new data set', ->
      it 'asks for more data'
