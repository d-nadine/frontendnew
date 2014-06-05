Radium.DateRangeComponent = Ember.Component.extend
  classNames: "date-range"
  width: null
  height: 100
  source: null
  margin: {top: 0, right: 30, bottom: 15, left: 30}
  domain: []

  componentWidth: ->
    @$().parent().innerWidth()

  svg: Ember.computed ->
    d3.select(this.$()[0]).append("svg")

  contextXScale: Ember.computed 'domain', ->
    d3.time.scale()
      .range([0, @componentWidth()])
      .domain(@get('domain'))

  contextAxis: Ember.computed 'contextXScale', ->
    d3.svg.axis()
      .scale(@get('contextXScale'))
      .tickFormat((d) ->
        format = d3.time.format('%b')
        format(d)
      )
      .tickSize(10)
      .orient("bottom")

  setupCanvas: (->
    brush = @brush = d3.svg.brush()
                    .x(@get('contextXScale'))
                    .on("brush", @brushDidChange.bind(this))
                    .on("brushstart", => @set 'isDragging', true)
                    .on("brushend", => @set 'isDragging', false)

    context = @svgContext = this.get('svg').append("g")
      .attr("class", "context")

    context.append("g")
      .attr("class", "x axis top")
      .attr("transform", "translate(0,0)")
      .call(@get('contextAxis'))
      .selectAll("text")
        .style("text-anchor", "start")

    context.append("g")
      .attr("class", "x brush")
      .call(brush)
      .selectAll("rect")
        .attr("y", 0)
        .attr("height", @get('height') - 2)

    @setDimensions()
    $(window).on('resize', @redraw.bind(this))
  ).on('didInsertElement')

  setDimensions: ->
    width = @componentWidth()
    height = @get 'height'

    @get('svg').attr("width", width - 5)
        .attr("height", height)

  redraw: ->
    @setDimensions()
    @get('svg').selectAll(".brush").call(@brush);

  dateRangeDidChange: (->
    return if @get 'isDragging'
    startDate = @get('startDate')
    endDate = @get('endDate')
    domain = @get('domain')
    domainStart = Ember.DateTime.create(domain[0].getTime())
    domainEnd = Ember.DateTime.create(domain[1].getTime())

    if startDate.isTheSameDayAs(domainStart) and endDate.isTheSameDayAs(domainEnd)
      @brush.clear()
    else
      @brush.extent([startDate.toJSDate(), endDate.toJSDate()])
      
    @redraw()
  ).observes('startDate', 'endDate')

  brushDidChange: () ->
    if @brush.empty()
      @sendAction('reset')
    else
      @set 'isDragging', true
      extent = @brush.extent()
      @sendAction('filter', [extent[0], extent[1]])
    dc.redrawAll()

Ember.Handlebars.helper('date-range', Radium.DateRangeComponent)