describe "a paged dataset", ->
  beforeEach ->
    @sandbox.stub @store, 'findQuery', => @content = ['bob', 'bobo']
    @dataset = Radium.PagedDataset.create
      type: 'contact'
      store: @store
      params:
        q: 'bob'
        private: true

  it 'defaults to the first page', ->
    expect(@dataset.get('page')).to.equal 1

  it 'uses the content', ->
    expect(@dataset.get('length')).to.equal 2
  it 'proxies the content', ->
    expect(@dataset.get('lastObject')).to.equal 'bobo'

  it 'passes on the filters on to the server', ->
    expect(@store.findQuery).to.have.been.calledWith 'contact', {q: 'bob', private: true, page: 1}

  describe 'changing the page', ->
    beforeEach ->
      @dataset.set('page', 5)
    it 'grabs the next page', ->
      expect(@store.findQuery).to.have.been.calledWith 'contact', {q: 'bob', private: true, page: 5}

    describe 'changing the query params', ->
      beforeEach ->
        @dataset.set 'params',
          q: 'fred'
          private: false
      it 'resets the page to page 1', ->
        expect(@dataset.get('page')).to.equal 1
      it 'asks for the first page of the new dataset with filters', ->
        expect(@store.findQuery).to.have.been.calledWith 'contact', {q: 'fred', private: false, page: 1}

  describe 'asking for the next page programmatically', ->
    beforeEach ->
      @dataset.pageForward()
    it 'advances the page', ->
      expect(@dataset.get('page')).to.equal 2
    it 'askes for the next page with filters', ->
      expect(@store.findQuery).to.have.been.calledWith 'contact', {q: 'bob', private: true, page: 2}
    describe 'asking for the previous page', ->
      beforeEach ->
        @store.findQuery.reset()
        @dataset.pageBackward()
      it 'rolls the page backward', ->
        expect(@dataset.get('page')).to.equal 1
      it 'runs the query again', ->
        expect(@store.findQuery).to.have.been.calledWith 'contact', {q: 'bob', private: true, page: 1}
