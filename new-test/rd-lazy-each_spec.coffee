describe "a lazy list", ->
  beforeEach ->
    height = 100
    rowHeight = 25
    horizon = 2
    list = null
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

    @content = Ember.A [
      {name: 'Barney'},
      {name: 'Fred'},
      {name: 'Betty'},
      {name: 'Wilma'}
    ]

    @extras = Ember.A [
      {name: 'Bam Bam'},
      {name: 'Pebbles'},
      {name: 'Dino'},
      {name: 'Mr. Slate'},
    ]

    @extra = {name: 'Bam Bam'}

    @endOfList = false
    @smallDataLoad = false

    @container = Ember.View.createWithMixins
      controller: @controller = Ember.Controller.createWithMixins
        actions:
          someAction: @action = sinon.spy ->
          moar: @moar = sinon.spy ->
      context: @controller

    @list = component Radium.RdLazyEachComponent,
      height: height
      rowHeight: rowHeight
      horizon: horizon
      content: @content
      endInSight: "moar"
      targetObject: @container.controller.actions
      template:
        Ember.Handlebars.compile('<div {{action "someAction"}} data-item>{{name}}</div>')
      _parentView: @container


  describe "when it is loaded at the beginning with all data showing", ->
    it "loads more data", ->
      expect(@moar).to.have.been.called
      expect($('[data-item]').length).to.equal 4
    describe "when no more data arrives", ->
      describe "scrolling some more", ->
        beforeEach ->
          @list.scroll
        it "does not ask for more data", ->
    describe "when data arrives, but still within the event horizon", ->
      beforeEach ->
        @content.addObject @extra
      it "asks for more data", ->
        expect(@moar).to.have.been.calledTwice
    describe "when data arrives, and expands the list beyond horizon", ->
      describe "scrolling within the horizon", ->
        it "does not ask for more data", ->
    describe "clicking on an action handler in the embedded template", ->
      beforeEach ->
        click '[data-item]:first'
      xit 'fires the action on the lazy-each components context', ->
        expect(@action).to.have.been.called
