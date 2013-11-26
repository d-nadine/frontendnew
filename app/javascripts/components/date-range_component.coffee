Radium.DateRangeComponent = Ember.Component.extend
  width: null
  height: 100
  source: null
  margin: {top: 0, right: 30, bottom: 15, left: 30}

  domain: [new Date(2013, 0, 1), new Date(2013, 11, 31)]

  setupCanvas: (->
    width = if @get('width') is null then @$().parent().width() - 60 else @get('width')
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
                    .on("brush", =>
                      @brushDidChange.call(this, brush)
                    )

    context = svg.append("g")
      .attr("class","context")
      .attr("transform", "translate(#{(margin.left + width * .25)},")

    context.append("g")
      .attr("class", "x axis top")
      .attr("transform", "translate(0,0)")
      .call(contextAxis)

    context.append("g")
      .attr("class", "x brush")
      .call(brush)
      .selectAll("rect")
        .attr("y", 0)
        .attr("height", height)

  ).on('didInsertElement')

  brushDidChange: (brush) ->
    if brush.empty()
      @get('source').setDates()
    else
      extent = brush.extent()
      @get('source').setDates(extent[0], extent[1])
    dc.redrawAll()

Ember.Handlebars.helper('date-range', Radium.DateRangeComponent)