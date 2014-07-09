describe 'loading data into a lazy list', ->
  height = 80
  rowHeight = 40
  horizon = 2
  list = null
  beforeEach ->
    $('body').append $ """
    <style>
      ember-list-view {
        overflow: auto;
        position: relative;
      }
      .ember-list-item-view {
        position: absolute;
      }
    </style>
    """
    @moar = sinon.spy =>
      @list.get('content').pushObjects [
        {name: 'Bam Bam'},
        {name: 'Pebbles'},
        {name: 'Dino'},
        {name: 'Mr Slate'}
      ]
    @list = list = component 'rdLazyEach',
      height: height
      rowHeight: rowHeight
      horizon: horizon
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
  afterEach ->
    Ember.run @list, 'remove'

  it 'exists', ->
    expect(@list).to.exist
  it 'has the expected dimensions', ->
    expect(@list.$().height()).to.equal 80
  it 'contains all the items', ->
    expect(@list.$('[data-item]').length).to.equal 3
    expect(@list.$('[data-item]:first')).to.have.text "Barney"
    expect(@list.$('[data-item]:last')).to.have.text "Betty"

  calculateScrollTop = (index) ->
    (index * rowHeight)

  scroll = (index) ->
    list.scrollTo calculateScrollTop(index)

  scrollToHorizon = ->
    initiallyVisibleRows = height / rowHeight
    scroll list.get('content.length') - horizon + initiallyVisibleRows

  describe 'scrolling near the end', ->
    beforeEach ->
      @moar.reset()
      scroll 2
    it 'asks for more data', ->
      expect(@moar).to.have.been.calledOnce

    it 'still contains only three items', ->
      expect(@list.$('[data-item]').length).to.equal 3

    it 'contains the expected items', ->
      #Bam Bam is first because the text of the first div has been replaced
      expect(@list.$('[data-item]:first')).to.have.text "Bam Bam"
      expect(@list.$('[data-item]:last')).to.have.text "Wilma"

    describe 'scrolling just a bit more', ->
      beforeEach ->
        @moar.reset()
        scroll 3
      it 'does not ask for more data', ->
        expect(@moar).not.to.have.been.called

      describe 'scrolling to the end of the new data set', ->
        beforeEach ->
          @moar.reset()
          scrollToHorizon()
        it 'asks for more data', ->
          expect(@moar).to.have.been.calledOnce
