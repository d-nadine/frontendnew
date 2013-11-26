Radium.DateRangeComponent = Ember.Component.extend
  classNames: "date-range"
  width: null
  height: 100
  source: null
  margin: {top: 0, right: 30, bottom: 15, left: 30}

  domain: [new Date(2013, 0, 1), new Date(2013, 11, 31)]

  setupCanvas: (->
    width = if @get('width') is null then @$().parent().innerWidth() else @get('width')
    height = @get 'height'
    margin = @get 'margin'
    domain = @get 'domain'

    svg = d3.select(this.$()[0]).append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", (height + margin.top + margin.bottom))

    contextXScale = d3.time.scale()
                    .range([0, width])
                    .domain(domain)

    contextAxis = d3.svg.axis()
                    .scale(contextXScale)
                    .tickFormat((d) ->
                      format = d3.time.format('%b')
                      format(d)
                    )
                    .tickSize(height)
                    .orient("bottom")

    brush = d3.svg.brush()
                    .x(contextXScale)
                    .on("brush", @brushDidChange.bind(this))

    context = svg.append("g")
      .attr("class","context")
      .attr("transform", "translate(#{(margin.left + width * .25)},")

    context.append("g")
      .attr("class", "x axis top")
      .attr("transform", "translate(0,0)")
      .call(contextAxis)
      .selectAll("text")
        .style("text-anchor", "start")

    context.append("g")
      .attr("class", "x brush")
      .call(brush)
      .selectAll("rect")
        .attr("y", 0)
        .attr("height", height)

    @setProperties(
      brush: brush
      svg: svg
    )
  ).on('didInsertElement')

  dateRangeDidChange: (->
    brush = @get('brush')
    svg = @get('svg')
    startDate = @get('startDate')
    endDate = @get('endDate')

    brush.extent([startDate.toJSDate(), endDate.toJSDate()])
    svg.selectAll(".brush").call(brush);
  ).observes('startDate', 'endDate')

  brushDidChange: () ->
    brush = @get('brush')
    if brush.empty()
      @sendAction('reset')
    else
      extent = brush.extent()
      @sendAction('filter', [extent[0], extent[1]])
    dc.redrawAll()

Ember.Handlebars.helper('date-range', Radium.DateRangeComponent)